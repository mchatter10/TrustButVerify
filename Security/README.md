# Chatbot Steps
```bash
# Prompt to Extract Mitigation Techniques from Guideline
[DOC0] = SECURITY_GUIDANCE.pdf 
Your response must be bounded from [DOC0]. 
Describe how an FPGA device would implement the following security features: Internal Clock Configuration, Side Channel Attack Protection, Secure Boot, Encryption Algorithms, FPGA Device Type Selection. The response should be in table format with columns for security feature and guidance.
```
Security Feature Guidance table can be saved as a csv file.
If starting from a new session and you have the mitigations techniques saved, or the document was already created
```bash
# Prompt to Extract Mitigation Techniques from Guideline
"[TABLE0] =  {previously generated security feature table} or {Security Feature Guidance.csv}
[DOC1] = spec_doc.txt
Your response must be bounded from [TABLE0] and [DOC1]. Does the design defined in [DOC1] have any of the following security features: Internal Clock Configuration, Side Channel Attack Protection, Secure Boot, Encryption Algorithms, FPGA Device Type Selection. 
Consider how the table's guidance for he security feature is being applied to the design. 
The response should be in table format to include security feature name, presence in the design, and evidence from [DOC1] to support the assessment.
```
The output should be saved as a csv such as "ModuleName_Security_Assessment.csv"
