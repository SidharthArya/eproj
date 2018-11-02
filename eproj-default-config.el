(setq eproj/new-proj-recipes '(
			    ("c" "mkdir %pn;cd %pn; touch CMakeLists.txt;" "%pn/CMakeLists.txt")
			    ("c++" "mkdir %pn;cd %pn; touch CMakeLists.txt;" "%pn/CMakeLists.txt")
			    ("ruby" "cd %pr; ")
			    ("java" "mkdir %pn;cd %pn; touch build.gradle; mkdir -p src/main; mkdir src/test;" "%pn/build.gradle")
			    ("python" "cd %pr; ")
			    ("clojure" "lein new app %pn;" "%pn/project.clj")
			    ("rust" "cargo new %pn;" "%pn/Cargo.toml")
			    ("php" "cd %pr; ")
			    ("haskell" "cd %pr; ")
			    ("perl" "cd %pr; ")
			    ("javascript" "cd %pr; ")
			    ))
(setq eproj/build-recipes '(
			    ("c" "cd %pr; cmake .; make; ")
			    ("c++" "cd %pr; ")
			    ("ruby" "cd %pr; ")
			    ("java" "cd %pr; ")
			    ("python" "cd %pr; ")
			    ("clojure" "cd %pr; ")
			    ("rust" "cd %pr; cargo build;")
			    ("php" "cd %pr; ")
			    ("haskell" "cd %pr; ")
			    ("perl" "cd %pr; ")
			    ("javascript" "cd %pr; ")
			    ))

(setq eproj/execute-recipes '(
			      ("c" "./%pn")
			      ("rust" "cd %pr; ./target/debug/%pn;")
			      ))

(setq eproj/import-dirs '(
			  ("c" "/usr/include")
			  ("h" "/usr/include")
			  ("cpp" "/usr/lib64/gcc/x86_64-pc-linux-gnu/7.3.0/include/g++-v7")
			  ))
(setq eproj/import-replaces '(
			      ("c" (("#include<" "%id") (">" "")))
			      ("h" (("#include<" "%id") (">" "")))
			      ("cpp" (("#include<" "%id") (">" "")))
			      
			      ))
(setq eproj/import-regexp '(
			   ("c" "#include *<.*>")
			   ("h" "#include *<.*>")
			   ("cpp" "#include *<.*>")
			  
			   ))
(setq eproj/function-regexp '(
			      ("c"  "^.*\\w+ %fn ?\\(.*\\)")
			      ("h"  "^.*\\w+ %fn ?\\(.*\\)")
			      ("cpp"  "^.*\\w+ %fn ?\\(.*\\)")
			      ))
