(setq user-full-name "Dmitrii Egorov"
      user-mail-address "de@snarta.com")

(setq doom-theme 'doom-one)

(add-to-list 'initial-frame-alist '(fullscreen . maximized))

(setq display-line-numbers-type nil)

(setq doom-font (font-spec :family "Iosevka"))

(setq org-directory "~/org/")

(after! cider
  (setq cider-repl-pop-to-buffer-on-connect nil))

(map! (:leader
       (:map (clojure-mode-map clojurescript-mode-map emacs-lisp-mode-map)
        (:prefix ("k" . "lisp")
         "j" #'paredit-join-sexps
         "c" #'paredit-split-sexp
         "D" #'paredit-kill
         "d" #'sp-kill-sexp
         "<" #'paredit-backward-slurp-sexp
         ">" #'paredit-backward-barf-sexp
         "s" #'paredit-forward-slurp-sexp
         "b" #'paredit-forward-barf-sexp
         "r" #'paredit-raise-sexp
         "R" #'sp-rewrap-sexp
         "w" #'paredit-wrap-sexp
         "[" #'paredit-wrap-square
         "'" #'paredit-meta-doublequote
         "{" #'paredit-wrap-curly
         "y" #'sp-copy-sexp))))

(map! :leader
      (:prefix-map ("p" . "project")
       :desc "implementation <-> test"      "a" #'projectile-toggle-between-implementation-and-test))

(after! cider
  (set-popup-rules!
   '(("^\\*cider-repl"
      :side right
      :width 100
      :quit nil
      :ttl nil))))

(defun clj-insert-persist-scope-macro ()
  (interactive)
  (insert
   "(defmacro persist-scope
              \"Takes local scope vars and defines them in the global scope. Useful for RDD\"
              []
              `(do ~@(map (fn [v] `(def ~v ~v))
                  (keys (cond-> &env (contains? &env :locals) :locals)))))"))

(defun persist-scope ()
  (interactive)
  (let ((beg (point)))
    (clj-insert-persist-scope-macro)
    (cider-eval-region beg (point))
    (delete-region beg (point))
    (insert "(persist-scope)")
    (cider-eval-defun-at-point)
    (delete-region beg (point))))

(add-hook 'php-mode-hook 'my-php-mode-hook)

(defun my-php-mode-hook ()
  "My PHP mode configuration."
  (setq indent-tabs-mode nil
        tab-width 2
        c-basic-offset 2))
