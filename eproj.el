;; eproj.el -- Make Projects simpler
;; This has been strictly created for linux based systems. Although systems with same lineage as linux, like BSD, Unix, Mac OSX may work as expected.
(require 'essentials)
(load eproj/config-location)
(load eproj/project-location)

(defvar eproj/project-type nil)
(defvar eproj/project-root nil)
(defvar eproj/project-name nil)
(defun eproj/make-config-file()
  "Create a make file"
  (interactive)
  (find-file eproj/config-location)
  (erase-buffer)
  (let ((insert-string (format "(setq eproj/new-proj-recipes '%S)\n" eproj/new-proj-recipes)))
    (insert insert-string)
    )
  (beginning-of-buffer)
  (while (re-search-forward ") (" nil t)
    (replace-match ")\n("))
  (beginning-of-buffer)
  (while (re-search-forward "((" nil t)
    (replace-match "(\n("))
  (beginning-of-buffer)
  (while (re-search-forward "))" nil t)
    (replace-match ")\n)"))
  (save-buffer)
  (kill-current-buffer)
  )

(defun eproj/make-projects-file()
  "Create a make file"
  (interactive)
  (find-file eproj/project-location)
  (erase-buffer)
  (let ((insert-string (format "(setq eproj/projects '%S)\n" eproj/projects)))
    (insert insert-string)
    )
  (beginning-of-buffer)
  (while (re-search-forward ") (" nil t)
    (replace-match ")\n("))
  (beginning-of-buffer)
  (while (re-search-forward "((" nil t)
    (replace-match "(\n("))
  (beginning-of-buffer)
  (while (re-search-forward "))" nil t)
    (replace-match ")\n)"))
  (save-buffer)
  (kill-current-buffer)
  )
(defun eproj/append-new-project-to-roots(a)
  "Append New Project"
  (if (equal (car a) eproj/project-type)
	(list (nth 0 a) (format "%s:%s" (nth 1 a) eproj/project-root))
      a
      )
  )



(defun eproj/create-project()
  "Create a new Project"
  (interactive)
  (setq eproj/project-type (ido-completing-read "Project Type:"  eproj/new-proj-recipes))
  (setq eproj/project-name (read-string "Enter Project's Name: "))
  
  (shell-command (insert-into-string (find-from-dict eproj/new-proj-recipes eproj/project-type) "%pn" eproj/project-name))
  
  (find-file (insert-into-string  (find-from-dict eproj/new-proj-recipes eproj/project-type 2 ) "%pn" eproj/project-name))
  (setq eproj/project-root (string-join (butlast (split-string (nth 1 (split-string (pwd))) "/")) "/"))
  (make-local-variable 'eproj/project-type)
  (make-local-variable 'eproj/project-root)
  (make-local-variable 'eproj/project-name)
  (setq eproj/projects (mapcar 'eproj/append-new-project-to-roots eproj/projects))
  (eproj/make-project-file)
  )

(add-to-list 'after-load-functions 'eproj/set-project)

(defun eproj/set-project(&optional FILE)
  "Sets the project type"
  (interactive)
  (setq checklist (mapcar (lambda(a) (split-string (nth 1 a) ":")) eproj/projects))
  (setq searchloc (nth 1 (split-string (pwd))))
  (setq found nil)
  (setq val nil)
  (while (and
	  (equal found nil)
	  (not (equal searchloc "")))
    (setq val (eproj/check-from-list searchloc checklist))
    (if (not (equal val nil))
    	(progn 
	 (setq found t)
    	(setq eproj/project-type (nth 0 (nth val eproj/projects)))
    	(setq eproj/project-root searchloc)
    	(setq eproj/project-name (car (last (split-string searchloc "/" )) ))
	(make-local-variable 'eproj/project-type)
	(make-local-variable 'eproj/project-root)
	(make-local-variable 'eproj/project-name)

	(message "Project Name: %s \nProject Type: %s \nProject Root: %s" eproj/project-name eproj/project-type eproj/project-root)
	)
    (setq searchloc (string-join (butlast (split-string searchloc "/")) "/"))
      )
    )
    )
(defun eproj/search-in-project()
  "Sets the project type"
  (interactive)
    (rgrep (read-string "Search: ") "*" eproj/project-root)
  )

(defun eproj/check-from-list(string list-of-list)
  "Check position"
  (position string list-of-list :test (lambda (a b) (position a b :test (lambda (c d) (equal c d)))))
  )

(defun eproj/compile-project()
  "Create a new Project"
  (execute-extended-command "abc")
  (ido-completing-read
          "M-x "
          (all-completions "" obarray 'commandp))
  )

(provide 'eproj)
