(setq eproj/new-proj-recipes '(
			    ("c" "mkdir %pn;cd %pn; touch CMakeLists.txt;" "%pn/CMakeLists.txt")
			    ("c++" "mkdir %pn;cd %pn; touch CMakeLists.txt;" "%pn/CMakeLists.txt")
			    ("ruby" "cd %pr; ")
			    ("java" "mkdir %pn;cd %pn; touch build.gradle; mkdir -p src/main; mkdir src/test;" "%pn/build.gradle")
			    ("python" "cd %pr; ")
			    ("clojure" "lein new app %pn;" "%pn/project.clj")
			    ("rust" "cargo new %pn;" "%pn/Cargo.toml")
			    ("php" "cd %pr; ")
			    ("haskell" "stack new %pn; " "%pn/Setup.hs")
			    ("perl" "mkdir %pn; cd &pn;" "%pn/%pn.pl")
			    ("javascript" "mkdir %pn; cd %pn; npm init --yes;" "%pn/package.json")
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
			    ("haskell" "cd %pr; stack build; ")
			    ("perl" "cd %pr; ")
			    ("javascript" "cd %pr; ")
			    ))


(setq eproj/execute-recipes '(
			      ("c" "cd %pr; ./%pn ")
			      ("c++" "cd %pr; ")
			      ("rust" "cd %pr; ./target/debug/%pn;")
			      ("ruby" "cd %pr; ")
			      ("java" "cd %pr; ")
			      ("python" "cd %pr; ")
			      ("clojure" "cd %pr; ")
			      ("rust" "cd %pr; cargo build;")
			      ("php" "cd %pr; ")
			      ("haskell" "cd %pr; ")
			      ("perl" "cd %pr; perl ./%pn.pl")
			      ("javascript" "cd %pr; node $(cat package.json | grep \"main\"| sed 's/\"/ /g' | awk '{print $3}')")
			    
			      ))

(setq eproj/import-dirs '(
			  ("c" "/usr/include")
			  ("h" "/usr/include")
			  ("cpp" "/usr/lib64/gcc/x86_64-pc-linux-gnu/7.3.0/include/g++-v7")
			  ))

(setq eproj/import-replaces '(
			      ("c" (("#include<" "%id") (">" "")))
			      ("cpp" (("#include<" "%id") (">" "")))
			      
			      ))

(setq eproj/import-regexp '(
			   ("c" "(?<=#include\s[<\"]).*(?=[>\"])")
			   ("h" "#include *<.*>")
			   ("cpp" "#include *<.*>")
			  
			   ))

(setq eproj/function-regexp '(
			      ("c"  "^.*\\w+ %fn ?\\(.*\\)")
			      ("h"  "^.*\\w+ %fn ?\\(.*\\)")
			      ("cpp"  "^.*\\w+ %fn ?\\(.*\\)")
			      ))
