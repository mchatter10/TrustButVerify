# Chatbot Steps to Generate Assertions

## Step 1: Extract Mitigation Techniques
The following prompt is to extract mitigation techniques from a specified FPGA design guideline document. <br>
- Submodule_Spec_Doc: the design or product specification document of the submodule as a .txt or .pdf file.
- interface_file: the testbench interface file for the submodule as a .txt file.
- signal_test_cases: the previously generated table of test cases for the signal of interest that impacts the specified security feature as a .csv or reference to table if in an active chat session. <br>
For high-quality results, it is recommended for the interface file to have some instantiated signals and written assertions that are successful in simulation.<br>

```bash
[DOC1]   = {Submodule_Spec_Doc}
[DOC2]   = {interface_file}
[TABLE3] = {signal_test_cases}
Your response must be bounded from [DOC1], [DOC2], [TABLE3], and prior knowledge of SystemVerilog Assertions for Hardware Verification. 
Generate additional assertions for [DOC2] to check the expected behavior for all [TABLE3] test cases. 
Each assertion must map back to a test case.
Instantiate signals that are added to the file.
```
The output may vary as an updated interface file with the added assertions, or an ouput with only the addtional assertions. <br>
It is recomeended for the verfication engineer to inspect the generated results for obvious errors or incorrect references to signal. <br>
Any new signals that were not in the original interface file must be instantiate and, if applicable, added to the sva binding file.
