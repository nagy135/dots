;; Basic Settings
(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)
(setq inhibit-startup-message t) ;; hide the startup message
;; (global-linum-mode t) ;; enable line numbers globally


;; Set default font size
(set-face-attribute 'default nil :height 120)
(set-frame-font "League Mono 13" nil t)

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
 '(auto-insert-mode t)
 '(custom-enabled-themes (quote (distinguished)))
 '(custom-safe-themes
   (quote
    ("0d456bc74e0ffa4bf5b69b0b54dac5104512c324199e96fc9f3a1db10dfa31f3" default)))
 '(line-number-mode nil)
 '(package-selected-packages
   (quote
    (django-theme snippet autopair paredit-everywhere eyebrowse emmet-mode org-bullets fontawesome helm-rg ranger direx-grep web-mode python-django evil-surround evil-commentary ecb go-mode jedi-direx jedi projectile dumb-jump magit neotree ## auto-complete paredit flycheck elpy distinguished-theme material-theme better-defaults helm evil))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-block ((t (:inherit fixed-pitch))))
 '(org-document-info ((t (:foreground "dark orange"))))
 '(org-document-info-keyword ((t (:inherit (shadow fixed-pitch)))))
 '(org-document-title ((t (:inherit default :weight bold :foreground "#f0fef0" :font "League Mono" :height 2.0 :underline nil))))
 '(org-indent ((t (:inherit (org-hide fixed-pitch)))))
 '(org-level-1 ((t (:inherit default :foreground "#19a85b" :slant normal :weight normal :height 1.75 :width normal :foundry "UKWN" :family "League Mono"))))
 '(org-level-2 ((t (:inherit default :foreground "#304bcc" :slant normal :weight normal :height 1.5 :width normal :foundry "UKWN" :family "League Mono"))))
 '(org-level-3 ((t (:inherit default :foreground "#c22330" :slant normal :weight normal :height 1.25 :width normal :foundry "UKWN" :family "League Mono"))))
 '(org-level-4 ((t (:inherit default :weight bold :foreground "#f0fef0" :font "League Mono" :height 1.1))))
 '(org-level-5 ((t (:inherit default :weight bold :foreground "#f0fef0" :font "League Mono"))))
 '(org-level-6 ((t (:inherit default :weight bold :foreground "#f0fef0" :font "League Mono"))))
 '(org-level-7 ((t (:inherit default :weight bold :foreground "#f0fef0" :font "League Mono"))))
 '(org-level-8 ((t (:inherit default :weight bold :foreground "#f0fef0" :font "League Mono"))))
 '(org-link ((t (:foreground "royal blue" :underline t))))
 '(org-meta-line ((t (:inherit (font-lock-comment-face fixed-pitch)))))
 '(org-property-value ((t (:inherit fixed-pitch))) t)
 '(org-special-keyword ((t (:inherit (font-lock-comment-face fixed-pitch)))))
 '(org-tag ((t (:inherit (shadow fixed-pitch) :weight bold :height 0.8))))
 '(org-verbatim ((t (:inherit (shadow fixed-pitch))))))

;; Evil 
(require 'evil)
(evil-mode 1)

;; Helm
(require 'helm-config)

;; Projectile
(require 'projectile)

;; Relative numbers
;; (require 'linum-relative)

;; Ag
(require 'ag)

;; autopair
(require 'autopair)
(autopair-global-mode)

;; Eyebrowse
(eyebrowse-mode t)
(eyebrowse-setup-evil-keys)

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

;; Create notes from highlighted text ->> "~/.random_notes" with comment
(defun highlight-to-notes (start end)
  (interactive "r")
    (if (use-region-p)
        (let ((this-file-path (buffer-file-name))(regionp (buffer-substring start end)))
            (write-region (concat "* "(read-from-minibuffer "Set comment to note: *") "\n" "** " this-file-path "\n" regionp "\n\n") t "~/.random_notes.org" t))))

;; Org mode
(require 'org)
(setq org-hide-emphasis-markers t)
(font-lock-add-keywords 'org-mode
                        '(("^ *\\([-]\\) "
                           (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))
(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
(let* ((variable-tuple
        (cond ((x-list-fonts "League Mono") '(:font "League Mono"))
              ((x-list-fonts "FontAwesome")   '(:font "FontAwesome"))
              ((x-list-fonts "Verdana")         '(:font "Verdana"))
              ((x-family-fonts "Sans Serif")    '(:family "Sans Serif"))
              (nil (warn "Cannot find a Sans Serif Font.  Install Source Sans Pro."))))
       (base-font-color     (face-foreground 'default nil 'default))
       (headline           `(:inherit default :weight bold :foreground ,base-font-color)))

  (custom-theme-set-faces
   'user
   `(org-level-8 ((t (,@headline ,@variable-tuple))))
   `(org-level-7 ((t (,@headline ,@variable-tuple))))
   `(org-level-6 ((t (,@headline ,@variable-tuple))))
   `(org-level-5 ((t (,@headline ,@variable-tuple))))
   `(org-level-4 ((t (,@headline ,@variable-tuple :height 1.1))))
   `(org-level-3 ((t (,@headline ,@variable-tuple :height 1.25))))
   `(org-level-2 ((t (,@headline ,@variable-tuple :height 1.5))))
   `(org-level-1 ((t (,@headline ,@variable-tuple :height 1.75))))
   `(org-document-title ((t (,@headline ,@variable-tuple :height 2.0 :underline nil))))))
(custom-theme-set-faces
 'user
 '(org-block                 ((t (:inherit fixed-pitch))))
 '(org-document-info         ((t (:foreground "dark orange"))))
 '(org-document-info-keyword ((t (:inherit (shadow fixed-pitch)))))
 '(org-link                  ((t (:foreground "royal blue" :underline t))))
 '(org-meta-line             ((t (:inherit (font-lock-comment-face fixed-pitch)))))
 '(org-property-value        ((t (:inherit fixed-pitch))) t)
 '(org-special-keyword       ((t (:inherit (font-lock-comment-face fixed-pitch)))))
 '(org-tag                   ((t (:inherit (shadow fixed-pitch) :weight bold :height 0.8))))
 '(org-verbatim              ((t (:inherit (shadow fixed-pitch)))))
 '(org-indent                ((t (:inherit (org-hide fixed-pitch))))))
(setq org-log-done t)
(setq org-agenda-files (list "~/.org/work_todo.org"
                             "~/.org/home_todo.org"))

;; Setup projectile projects
(setq projects-list '("~/Code/joga" "~/go/src/github.com/nagy135/lego/"))
(dolist (project-path projects-list)
  (projectile-add-known-project project-path))
(setq helm-locate-project-list projects-list)

;; Modes
;; (linum-relative-mode) ;; relative numberline mode
(evil-commentary-mode) ;; commentary mode (gcc)
(global-evil-surround-mode) ;; surround mode

(defun show-file-name ()
  "Show the full path file name in the minibuffer."
  (interactive)
  (message (buffer-file-name)))

;; Bindings
(global-set-key (kbd "C-x f") 'helm-find-files) ;; because i press it a lot without control
(global-set-key (kbd "C-h C-h") 'helm-M-x) ;; use helm instead of default help
(global-set-key (kbd "C-u") 'evil-scroll-up) ;; why isnt this default?
(global-set-key (kbd "C-x C-s") 'eval-buffer) ;; evaluate current buffer
(global-set-key (kbd "C-x C-c") (lambda() (interactive)(find-file "~/.emacs"))) ;; open .emacs file
(global-set-key (kbd "C-x g") 'magit-status) ;; git status
;; (define-key global-map "\C-cp" 'projectile-find-file-in-known-projects) ;; find file in projects from projects-list
(define-key global-map (kbd "C-c p") 'helm-projects-find-files) ;; find file in projects from projects-list
(define-key global-map "\C-cg" 'ag-project) ;; ag string in current project
(define-key global-map "\C-xp" 'ac-complete-filename) ;; filepath completion
(define-key global-map (kbd "M-p M-i") 'package-install) ;; fast package-install
(define-key global-map "\C-ca" 'org-agenda) ;; show org todo agenda
(define-key global-map "\C-ct" 'helm-semantic-or-imenu) ;; helm search in tags
(define-key global-map "\C-cs" 'eshell) ;; helm search in tags
(define-key global-map "\C-cn" '(helm :sources projects-list)) ;; Choose between options
(define-key global-map (kbd "C-x C-b")'helm-buffers-list) ;; Choose open buffer
(global-set-key (kbd "C-c C-g") 'ag-proj-regex) ;; search in custom projects
(global-set-key (kbd "C-c h n") 'highlight-to-notes) ;; search in custom projects
(global-set-key (kbd "C-c f n") 'show-file-name) ;; show file path of current buffer
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
