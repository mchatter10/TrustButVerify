# Chatbot Steps

## Step 1: Extract Relevant Signals
The following prompt is to create a table of signals that directly impact the specified security feature. <br>
- Submodule_Spec_Doc: the design or product specification document of the submodule as a .txt or .pdf file. <br>
- ModuleName_Security_Assessment: the security assessment of the specified design as a .csv or reference to table if in an active chat session.
For high-quality results, if the submodule specificaitons are embedded in the system specification, it is recommended to seperate the submodule into a sepearate file. This will help focus the LLM to the contents of the submodule <br>
- security_feature: one security feature from the assessment. <br>

```bash
"[DOC1] = {Submodule_Spec_Doc.pdf}
[TABLE1] = {ModuleName_Security_Assessment.csv}
Your response must be bounded from [DOC1]. List all signals of the design that impact {security_feature}"
```
Signal table can be saved as a csv or txt file such as "Extracted_Signals.csv"


## Step 2: Signal Dependency Map
The following prompt is to create a table that maps the signals of interest to other signals that they are related to.<br>
- Submodule_Spec_Doc: the design or product specification document of the submodule as a .txt or .pdf file. <br>
- sigal_list: an optional file that contains more detailed descriptions of signals (ports, registers, etc.) and their behaviors, state transitions, timing, etc. as a .csv, .txt, .or .pdf file.
- Extracted_Signals: the previously generated table of signals that impact the security feature of interest as a .csv or reference to table if in an active chat session.
- signal: the signal of interest
```bash
[DOC0] = {sigal_list}
[DOC1] = {Submodule_Spec_Doc}
[TABLE1] = {Extracted_Signals}
Your response must be bounded from [DOC1] and any recollection of dependency graphs from computer architecture. Create a table to show what signals are related to the {signal} register. The table must include the signal and relationship description
```

## Step 3: Test Case Generation
The following prompt is to create a table of test cases that test the behavior of the signals that directly impact the selected security feature.<br>

- signal_dependencies
- Submodule_Spec_Doc: the design or product specification document of the submodule as a .txt or .pdf file. <br>
- sigal_list: an optional file that contains more detailed descriptions of signals (ports, registers, etc.) and their behaviors, state transitions, timing, etc. as a .csv, .txt, .or .pdf file.
- signal: the signal of interest
```bash
[DOC0] = {sigal_list}
[DOC1] =  {Submodule_Spec_Doc}
[TABLE2] = {signal_dependencies}
Your response must be bounded from [DOC0], [DOC1],[TABLE2], and knowledge of defining test cases for a Hardware Verification Test Plan.
Define test cases for the {signal} signal to demonstrate signal behavior and timing relationships for the design. The response must be a table that includes: Test case ID, Test name, test case description, stimulus description, and description of the expected behavior
```
