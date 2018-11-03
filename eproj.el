;; eproj.el --- Make Projects simpler
;; This has been strictly created for linux based systems. Although systems with same lineage as linux, like BSD, Unix, Mac OSX may work as expected.
;; It is very tightly bound to shell commands.
(require 'essentials)

(if (boundp 'eproj/config-location)
    (load eproj/config-location)
  (load "./eproj-default-config.el"))
(if (boundp 'eproj/project-location)
    (load eproj/project-location)
  (progn
    (setq eproj/project-location "~/.emacs.d/eproj-projects")
    (if (file-exists-p eproj/project-location)
	(load eproj/project-location)
      (progn
	(load "./eproj-init-projects.el")
	(eproj/make-project-file)
	)
      )
    )
  )
(defvar eproj/project-type nil)
(defvar eproj/project-root nil)
(defvar eproj/project-name nil)
(defvar eproj/file-name nil)
(defvar eproj/file-extension nil)
(defun eproj/set-file()
  "Set File 
This function will set the necessary variables for certain other headers to work. 
It sets the eproj/file-extension variable from the current file name. 
It may not be of any use to call this function. since it has already be 
added to the list of functions which get called after the files are loaded.

"
  (interactive)
  (setq eproj/file-name (buffer-file-name))
  (if (not (equal eproj/file-name nil))
      (setq eproj/file-extension (file-name-extension eproj/file-name))
    )
  (make-local-variable 'eproj/file-name)
  (make-local-variable 'eproj/file-extension)
  )
  
(defun eproj/assume-file-type(EXTENSION)
  "Assume file of Type
This function makes the eproj library see the current file appear as if it had an
extension which is provided as an argument.
"
  (setq eproj/file-extension EXTENSION)
  (make-local-variable 'eproj/file-extension)
  )

(defun eproj/ask-file-type()
  "Ask File Type
This function is an extension to the function eproj/assume-file-type for the users.
The users may specify the file extension interactively. so that the file is processed 
as having another extension by the eproj library.
"
  (interactive)
  (eproj/assume-file-type (ido-completing-read "Assume as file type:" eproj/import-dirs))
  )


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

(defun eproj/initial-file()
  "Create the initial Project "
  )
(defun eproj/create-project()
  "Create a new Project"
  (interactive)
  (setq eproj/project-type (ido-completing-read "Project Type:"  eproj/new-proj-recipes))
  (setq eproj/project-name (read-string "Enter Project's Name: "))
  
  (async-shell-command (insert-into-string (find-from-dict eproj/new-proj-recipes eproj/project-type) "%pn" eproj/project-name))
  
  (find-file (insert-into-string  (find-from-dict eproj/new-proj-recipes eproj/project-type 2 ) "%pn" eproj/project-name))
  (setq eproj/project-root (string-join (butlast (split-string (nth 1 (split-string (pwd))) "/")) "/"))
  (make-local-variable 'eproj/project-type)
  (make-local-variable 'eproj/project-root)
  (make-local-variable 'eproj/project-name)
  (setq eproj/projects (mapcar 'eproj/append-new-project-to-roots eproj/projects))
  (eproj/make-projects-file)
  )

(add-to-list 'after-load-functions 'eproj/set-project)

(defun eproj/set-project(&optional FILE)
  "Sets the project type"
  (interactive)
  (eproj/set-file)
  (setq checklist (mapcar (lambda(a) (split-string (nth 1 a) ":")) eproj/projects))
  (setq searchloc (nth 1 (split-string (pwd))))
  (setq found nil)
  (setq val nil)
  (while (and
	  (equal found nil)
	  (not (equal searchloc ""))
	  (not (equal searchloc "~")))

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
  "Check cl-position"
  (cl-position string list-of-list :test (lambda (a b) (cl-position a b :test (lambda (c d) (equal c d)))))
  )

(defun eproj/build-project()
  "Create a new Project"
  (interactive)
      (async-shell-command (insert-into-string (find-from-dict eproj/build-recipes eproj/project-type) "%pr" eproj/project-root))
  )
(defun eproj/execute-project(&optional arguments time-boolean)
  "Create a new Project"
  (interactive)
  (let ((shellcommand(format "%s %s" (insert-into-string (insert-into-string (find-from-dict eproj/execute-recipes eproj/project-type) "%pr" eproj/project-root) "%pn" eproj/project-name) (if (equal arguments nil) "" arguments))))
    (if time-boolean
	(progn
	  (setq shellcommand (split-string shellcommand ";"))
	  (setq shellcommand (string-join (append (butlast shellcommand) (list (concat "time " (car (last shellcommand))))) ";"))
	  (print shellcommand)
   )) (async-shell-command shellcommand)
    )
  )
(defun eproj/refractor-replace()
  "Refractor Replace"
  (interactive)
    )
(defun eproj/set-headers()
  "Goto Header"
  (interactive)
  (let* (
	 (file-name eproj/file-name)
	 (file-extension eproj/file-extension)
	 (header-format-replaces (find-from-dict eproj/import-replaces file-extension))
	(include-locations (split-string (format "%s:."(find-from-dict eproj/import-dirs file-extension)) ":"))
	(headers (split-string (string-trim (shell-command-to-string (format "grep -Po '%s' %s" (find-from-dict eproj/import-regexp file-extension)  file-name))) "\n"))
	)
    (setq eproj/headers '())
    (mapcar (lambda (incl) (mapcar (lambda(head) (if (file-exists-p (format "%s/%s" incl head))
						     (add-to-list 'eproj/headers (format "%s/%s" incl head)))
						     ) headers)) include-locations)
    (make-local-variable 'eproj/headers)
    ))
(defun eproj/goto-header()
  "Goto Header"
  (interactive)
  (let* (
	 (file-name eproj/file-name)
	 (file-extension eproj/file-extension)
	 (include-locations (split-string (format "%s:." (find-from-dict eproj/import-dirs file-extension)) ":"))
      	 (header (thing-at-point 'filename t))
	 )
    (mapcar (lambda (a) (if (file-exists-p (string-join (list a header) "/")) (find-file (string-join (list a header) "/")))) include-locations)

   ))

(defun eproj/goto-function()
  "Goto a function in header"
  (interactive)
  (let* (
	 (file-extension eproj/file-extension)
	 (regex (insert-into-string (find-from-dict eproj/function-regexp file-extension) "%fn" (thing-at-point 'symbol t))))
    (setq temp (split-string (shell-command-to-string (format "grep -Pn '%s' %s %s " regex  (string-join eproj/headers " ") (buffer-file-name))) ":"))
    (if (file-exists-p (car temp))
	(progn
	  (find-file (car temp))
	  (eproj/assume-file-type file-extension)
	  (goto-line (string-to-number (car (cdr temp))))))
    (message "Function Not Found"))
     )

(require 'ls-lisp)
    
  (provide 'eproj)
  

