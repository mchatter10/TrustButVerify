# Chatbot Steps

## Step 1: Extract Mitigation Techniques
The following prompt is to extract mitigation techniques from a specified FPGA design guideline document. <br>
- Security_Guideance_file: the Security Guideance document in a .txt, .csv, or .pdf. <br>
- [security_features]: a list of security features the user provides such as: "Secure Boot, Encryption Algorithms" <br>
For high-quality results, it is recommended to provide a list of features that exist in the referenced guideline document.<br>

```bash
"[DOC0] = {Security_Guidance_file} 
Your response must be bounded from [DOC0]. 
Describe how an FPGA device would implement the following security features:
{[security_features]}
The response should be in table format with columns for security feature and guidance."
```
Security Feature Guidance table can be saved as a csv or txt file. In this example, the table 


## Step 2: Security Assessment
The following prompt is to generate a security assessment of the specified design. <br>
- Extracted_Guidance: If starting from a new session, this is the table mitigation techniques generated from Step 1. Either upload this file, or reference the table as "the previously generated security feature table. <br>
- spec_doc: The design or product specification document. The RTL code could be used as well, although it is recommended to use the design document to avoid an incorrect signal reference influencing the assessment. <br>
- [security_features]: the same list from Step 1.
```bash
# Prompt to Extract Mitigation Techniques from Guideline
"[TABLE0] = {Extracted_Guidance}
[DOC1] = {spec_doc}
Your response must be bounded from [TABLE0] and [DOC1].
Does the design defined in [DOC1] have any of the following security features:
{[security_features]} 
Consider how the table's guidance for he security feature is being applied to the design. 
The response should be in table format to include security feature name, presence in the design, and evidence from [DOC1] to support the assessment.
```
The output should be saved as a csv or plaintext file such as "ModuleName_Security_Assessment.csv"
