const TURN_COMPLETE_SOUND = "/System/Library/Sounds/Submarine.aiff";
const PERMISSION_ASKED_SOUND = "/System/Library/Sounds/Ping.aiff";

async function playSound($, path) {
  await $`afplay ${path}`.quiet().nothrow();
}

export const NotificationSoundsPlugin = async ({ $ }) => {
  return {
    event: async ({ event }) => {
      switch (event?.type) {
        case "session.idle":
          await playSound($, TURN_COMPLETE_SOUND);
          break;
        case "permission.asked":
          await playSound($, PERMISSION_ASKED_SOUND);
          break;
        default:
          break;
      }
    },
  };
};
