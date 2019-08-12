;; Basic Settings
(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)
(setq inhibit-startup-message t) ;; hide the startup message
(global-linum-mode t) ;; enable line numbers globally


;; Set default font size
(set-face-attribute 'default nil :height 120)
(set-frame-font "League Mono 15" nil t)

;; Package settings
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
			 ("melpa" . "https://melpa.org/packages/")))
(when (not package-archive-contents)
  (package-refresh-contents))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(custom-enabled-themes (quote (wheatgrass)))
 '(line-number-mode nil)
 '(package-selected-packages
   (quote
    (ranger direx-grep web-mode python-django evil-surround evil-commentary ecb go-mode linum-relative jedi-direx jedi projectile dumb-jump magit neotree ## auto-complete paredit flycheck elpy distinguished-theme material-theme better-defaults helm evil))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Evil 
(require 'evil)
(evil-mode 1)

;; Helm
(require 'helm-config)

;; Projectile
(require 'projectile)

;; Relative numbers
(require 'linum-relative)

;; Ag
(require 'ag)


;; Auto Complete
(require 'auto-complete-config)
(ac-config-default)
(setq ac-show-menu-immediately-on-auto-complete t)

;; Jedi
(require 'jedi)
(add-to-list 'ac-sources 'ac-source-jedi-direct)
(add-hook 'python-mode-hook 'jedi:setup)

;; Install packages if not installed
(defvar myPackages
  '(better-defaults
    elpy))

(mapc #'(lambda (package)
	  (unless (package-installed-p package)
	    (package-install package)))
      myPackages)

(elpy-enable) ;; Enable python mode
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

;; Paredit
(autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
(add-hook 'emacs-lisp-mode-hook       #'enable-paredit-mode)
(add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
(add-hook 'ielm-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
(add-hook 'scheme-mode-hook           #'enable-paredit-mode)

;; Neotree
(add-to-list 'load-path "/some/path/neotree")
(require 'neotree)
(global-set-key (kbd "C-c f f") 'neotree-toggle)
(global-set-key (kbd "C-c f t") 'neotree-find)
(add-hook 'neotree-mode-hook
              (lambda ()
                (define-key evil-normal-state-local-map (kbd "TAB") 'neotree-enter)
                (define-key evil-normal-state-local-map (kbd "SPC") 'neotree-quick-look)
                (define-key evil-normal-state-local-map (kbd "q") 'neotree-hide)
                (define-key evil-normal-state-local-map (kbd "RET") 'neotree-enter)
                (define-key evil-normal-state-local-map (kbd "g") 'neotree-refresh)
                (define-key evil-normal-state-local-map (kbd "n") 'neotree-next-line)
                (define-key evil-normal-state-local-map (kbd "p") 'neotree-previous-line)
                (define-key evil-normal-state-local-map (kbd "A") 'neotree-stretch-toggle)
                (define-key evil-normal-state-local-map (kbd "H") 'neotree-hidden-file-toggle)))

;; Org mode
(require 'org)
(setq org-log-done t)
(setq org-agenda-files (list "~/.org/work_todo.org"
                             "~/.org/home_todo.org"))

;; Setup projectile projects
(setq projects-list '("~/Code/django/joga" "~/Code/GoLemon" "~/go/src/github.com/nagy135/lego/"))
(dolist (project-path projects-list)
  (projectile-add-known-project project-path))

;; Modes
(linum-relative-mode) ;; relative numberline mode
(evil-commentary-mode) ;; commentary mode (gcc)
(global-evil-surround-mode) ;; surround mode

;; Bindings
(global-set-key (kbd "C-h C-h") 'helm-M-x) ;; use helm instead of default help
(global-set-key (kbd "C-u") 'evil-scroll-up) ;; why isnt this default?
(global-set-key (kbd "C-x C-s") 'eval-buffer) ;; evaluate current buffer
(global-set-key (kbd "C-x C-c") (lambda() (interactive)(find-file "~/.emacs"))) ;; open .emacs file
(global-set-key (kbd "C-x g") 'magit-status) ;; git status
(define-key global-map "\C-cp" 'projectile-find-file-in-known-projects) ;; find file in projects from projects-list
(define-key global-map "\C-cg" 'ag-project) ;; ag string in current project
(define-key global-map "\C-xp" 'ac-complete-filename) ;; filepath completion
(define-key global-map (kbd "M-p i") 'package-install) ;; fast package-install
(define-key global-map "\C-ca" 'org-agenda) ;; show org todo agenda
(define-key global-map "\C-ct" 'helm-semantic-or-imenu) ;; helm search in tags
(define-key global-map "\C-cs" 'shell) ;; helm search in tags
(define-key global-map "\C-cn" '(helm :sources projects-list)) ;; Choose between options
(define-key global-map (kbd "C-x C-b")'helm-buffers-list) ;; Choose open buffer
(global-set-key (kbd "C-c C-g") 'ag-proj-regex) ;; search in custom projects
;;(global-set-key (kbd "C-c p") (lambda() (interactive)(find-file my-new-global-var)(find-file-in-project)))
;;(global-set-key (kbd "C-c p")  (projectile-find-file))
;;(global-set-key (kbd "C-c g") (lambda() (interactive)(change-folder-ag)))

;; Persistant undo
(global-undo-tree-mode)
(setq undo-tree-auto-save-history t)
(setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))

;; Evil mode _ fix
(modify-syntax-entry ?_ "w")

(defun ag-proj-regex (string directory)
  "Search using ag in a given DIRECTORY for a given literal search STRING,
with STRING defaulting to the symbol under point.

If called with a prefix, prompts for flags to pass to ag."
  (interactive (list (ag/read-from-minibuffer "Search string in project")
		     (helm :sources (helm-build-sync-source "Choose from project"
					 :candidates projects-list)
			      :buffer "*helm sync source*")))
  (ag/search string directory))
