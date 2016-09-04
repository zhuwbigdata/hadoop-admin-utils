A = load '$INPUT_DIR/*' using PigStorage();
store A into '$OUTPUT_DIR/' using PigStorage();

