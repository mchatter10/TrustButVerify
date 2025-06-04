# Chatbot Steps

## Step 1: Extract Mitigation Techniques
The following prompt is to extract mitigation techniques from a specified FPGA design guideline document.
{[security_features]} is a list of security features the user provides such as: "Secure Boot, Encryption Algorithms"
For high-quality results, it is recommended to provide a list of features that exist in the guideline document.

```bash
"[DOC0] = SECURITY_GUIDANCE.pdf 
Your response must be bounded from [DOC0]. 
Describe how an FPGA device would implement the following security features:
{[security_features]}
The response should be in table format with columns for security feature and guidance."
```
Security Feature Guidance table can be saved as a csv file.
[TABLE0] is If starting from a new session and you have the mitigations techniques saved, or the document was already created.
{[security_features]} is the same list from Step 1.

## Step 2: Security Assessment
The following prompt is generate a security assessment of the specified design.
```bash
# Prompt to Extract Mitigation Techniques from Guideline
"[TABLE0] = {previously generated security feature table} or {Security Feature Guidance.csv}
[DOC1] = spec_doc.txt
Your response must be bounded from [TABLE0] and [DOC1].
Does the design defined in [DOC1] have any of the following security features:
{[security_features]} 
Consider how the table's guidance for he security feature is being applied to the design. 
The response should be in table format to include security feature name, presence in the design, and evidence from [DOC1] to support the assessment.
```
The output should be saved as a csv such as "ModuleName_Security_Assessment.csv"
