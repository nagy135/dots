import importlib.util
import subprocess
import tempfile
import threading
import time
import unittest
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path
from unittest.mock import patch


spec = importlib.util.spec_from_file_location(
    "tmuxish", Path(__file__).parents[1] / ".config/herdr/tmuxish.py"
)
tmuxish = importlib.util.module_from_spec(spec)
spec.loader.exec_module(tmuxish)


class SeshWorkspaceTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory()
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name).resolve()
        self.project = self.root / "project"
        self.project.mkdir()
        self.other = self.root / "other"
        self.other.mkdir()
        self.entry = {"Src": "zoxide", "Path": str(self.project)}
        self.workspaces = []
        self.panes = []
        self.focused = []
        self.created = []
        self.next_id = 1
        self.addCleanup(patch.stopall)
        patch.dict(
            tmuxish.os.environ,
            {"XDG_STATE_HOME": str(self.root / "state"), "HERDR_SOCKET_PATH": "test.sock"},
        ).start()
        patch.object(tmuxish, "herdr_json", side_effect=self.api).start()
        patch.object(tmuxish, "run", side_effect=self.run_command).start()

    def add_workspace(self, *paths, worktree=None):
        workspace_id = f"w{self.next_id}"
        self.next_id += 1
        self.workspaces.append({"workspace_id": workspace_id, "worktree": worktree})
        for index, path in enumerate(paths):
            self.panes.append(
                {"workspace_id": workspace_id, "pane_id": f"{workspace_id}:p{index}",
                 "cwd": str(path)}
            )
        return workspace_id

    def api(self, *args):
        if args == ("workspace", "list"):
            return {"result": {"workspaces": self.workspaces}}
        if args == ("pane", "list"):
            return {"result": {"panes": self.panes}}
        if args[:2] == ("workspace", "create"):
            self.created.append(args)
            workspace_id = self.add_workspace(args[args.index("--cwd") + 1])
            return {"result": {"workspace": {"workspace_id": workspace_id}}}
        self.fail(f"unexpected API call: {args}")

    def run_command(self, args, **kwargs):
        if args[:3] == [tmuxish.HERDR, "workspace", "focus"]:
            self.focused.append(args[3])
            return subprocess.CompletedProcess(args, 0)
        self.fail(f"unexpected command: {args}")

    def test_reuses_workspace_with_an_unrelated_pane(self):
        workspace_id = self.add_workspace(self.project, self.other)
        tmuxish.focus_or_create_sesh_workspace(self.entry)
        self.assertEqual(self.focused, [workspace_id])
        self.assertEqual(self.created, [])

    def test_reuses_workspace_after_cd_into_subdirectory(self):
        workspace_id = self.add_workspace(self.project / "src")
        tmuxish.focus_or_create_sesh_workspace(self.entry)
        self.assertEqual(self.focused, [workspace_id])
        self.assertEqual(self.created, [])

    def test_checks_shell_cwd_even_when_foreground_process_is_elsewhere(self):
        workspace_id = self.add_workspace(self.project)
        self.panes[0]["foreground_cwd"] = str(self.other)
        tmuxish.focus_or_create_sesh_workspace(self.entry)
        self.assertEqual(self.focused, [workspace_id])
        self.assertEqual(self.created, [])

    def test_remembers_created_workspace_after_every_pane_changes_directory(self):
        tmuxish.focus_or_create_sesh_workspace(self.entry)
        self.panes[0]["cwd"] = str(self.other)
        tmuxish.focus_or_create_sesh_workspace(self.entry)
        self.assertEqual(len(self.created), 1)
        self.assertEqual(self.focused, [self.workspaces[0]["workspace_id"]])

    def test_remembers_adopted_workspace_after_every_pane_changes_directory(self):
        workspace_id = self.add_workspace(self.project)
        tmuxish.focus_or_create_sesh_workspace(self.entry)
        self.panes[0]["cwd"] = str(self.other)
        tmuxish.focus_or_create_sesh_workspace(self.entry)
        self.assertEqual(self.focused, [workspace_id, workspace_id])
        self.assertEqual(self.created, [])

    def test_remembered_identity_wins_over_another_workspaces_current_directory(self):
        other_id = self.add_workspace(self.other)
        workspace_id = self.add_workspace(self.project)
        tmuxish.focus_or_create_sesh_workspace(self.entry)
        self.panes[0]["cwd"] = str(self.project)
        self.panes[1]["cwd"] = str(self.other)
        tmuxish.focus_or_create_sesh_workspace(self.entry)
        self.assertNotEqual(other_id, workspace_id)
        self.assertEqual(self.focused, [workspace_id, workspace_id])
        self.assertEqual(self.created, [])

    def test_concurrent_invocations_only_create_one_workspace(self):
        callers = 4
        ready = threading.Barrier(callers)

        def slow_api(*args):
            if args[:2] == ("workspace", "create"):
                time.sleep(0.05)
            return self.api(*args)

        def select():
            ready.wait(timeout=5)
            tmuxish.focus_or_create_sesh_workspace(self.entry)

        with patch.object(tmuxish, "herdr_json", side_effect=slow_api):
            with ThreadPoolExecutor(max_workers=callers) as pool:
                futures = [pool.submit(select) for _ in range(callers)]
                for future in futures:
                    future.result(timeout=5)
        self.assertEqual(len(self.created), 1)
        self.assertEqual(self.focused, [self.workspaces[0]["workspace_id"]] * (callers - 1))

    def test_exact_workspace_wins_over_workspace_in_a_subdirectory(self):
        self.add_workspace(self.project / "nested-project")
        workspace_id = self.add_workspace(self.project)
        tmuxish.focus_or_create_sesh_workspace(self.entry)
        self.assertEqual(self.focused, [workspace_id])

    def test_does_not_match_sibling_with_shared_prefix(self):
        self.add_workspace(self.root / "project-other")
        tmuxish.focus_or_create_sesh_workspace(self.entry)
        self.assertEqual(len(self.created), 1)
        self.assertEqual(self.focused, [])

    def test_symlink_path_reuses_canonical_workspace(self):
        alias = self.root / "alias"
        alias.symlink_to(self.project, target_is_directory=True)
        workspace_id = self.add_workspace(self.project)
        tmuxish.focus_or_create_sesh_workspace({"Src": "zoxide", "Path": str(alias)})
        self.assertEqual(self.focused, [workspace_id])
        self.assertEqual(self.created, [])

    def test_closed_workspace_is_recreated(self):
        tmuxish.focus_or_create_sesh_workspace(self.entry)
        self.workspaces.clear()
        self.panes.clear()
        tmuxish.focus_or_create_sesh_workspace(self.entry)
        self.assertEqual(len(self.created), 2)
        self.assertEqual(self.focused, [])

    def test_sessions_with_same_workspace_id_do_not_share_associations(self):
        tmuxish.focus_or_create_sesh_workspace(self.entry)
        self.panes[0]["cwd"] = str(self.other)
        with patch.dict(tmuxish.os.environ, {"HERDR_SOCKET_PATH": "other.sock"}):
            tmuxish.focus_or_create_sesh_workspace(self.entry)
        self.assertEqual(len(self.created), 2)

    def test_worktree_provenance_survives_cd_away(self):
        workspace_id = self.add_workspace(
            self.other, worktree={"checkout_path": str(self.project)}
        )
        tmuxish.focus_or_create_sesh_workspace(self.entry)
        self.assertEqual(self.focused, [workspace_id])
        self.assertEqual(self.created, [])

    def test_empty_path_is_rejected(self):
        with self.assertRaises(RuntimeError):
            tmuxish.focus_or_create_sesh_workspace({"Src": "zoxide"})
        self.assertEqual(self.created, [])

    def test_named_session_retains_custom_label(self):
        tmuxish.focus_or_create_sesh_workspace({**self.entry, "Src": "config", "Name": "dev"})
        self.assertIn("--label", self.created[0])
        self.assertEqual(self.created[0][self.created[0].index("--label") + 1], "dev")

    def test_failed_lookup_does_not_fall_back_to_creating_a_duplicate(self):
        with patch.object(
            tmuxish, "herdr_json", side_effect=subprocess.CalledProcessError(1, "herdr")
        ):
            with self.assertRaises(subprocess.CalledProcessError):
                tmuxish.focus_or_create_sesh_workspace(self.entry)
        self.assertEqual(self.created, [])

    def test_failed_focus_does_not_fall_back_to_creating_a_duplicate(self):
        self.add_workspace(self.project)
        with patch.object(
            tmuxish, "run", side_effect=subprocess.CalledProcessError(1, "herdr")
        ):
            with self.assertRaises(subprocess.CalledProcessError):
                tmuxish.focus_or_create_sesh_workspace(self.entry)
        self.assertEqual(self.created, [])


if __name__ == "__main__":
    unittest.main()
