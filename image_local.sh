    dune exec bin/scanner.exe -- -x .outlocal2 -c .out  -s ./huggingface/unimath/batch2/data_30/       -p "Consider the following possible scenes for a comic book and extract a list of characters and desribe one in detail.:"  --ollama -m "mistral" -u "http://localhost:11434"