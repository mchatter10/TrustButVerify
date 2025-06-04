# Chatbot Steps to Generate Test Cases

## Step 1: Extract Relevant Signals
The following prompt is to create a table of signals that directly impact the specified security feature. <br>
It is recommended to perform these steps on a submodule or IP. The selected submodule should be one that impacts multiple security features, as identified from the security assessment. <br>
- Submodule_Spec_Doc: the design or product specification document of the submodule as a .txt or .pdf file. <br>
- ModuleName_Security_Assessment: the security assessment of the specified design as a .csv or reference to table if in an active chat session.
For high-quality results, if the submodule specificaitons are embedded in the system specification, it is recommended to seperate the submodule into a sepearate file. This will help focus the LLM to the contents of the submodule <br>
- security_feature: one security feature from the assessment. <br>

```bash
[DOC1]    =  {Submodule_Spec_Doc.pdf}
[TABLE1]  =  {ModuleName_Security_Assessment.csv}
Your response must be bounded from [DOC1] and [DOC1].
List all input and output signals of the design that impact the {security_feature} of the design.
Only list the signals that directly impact {security_feature}.
Refer to [DOC0] for the evidence of the design features that provides {security_feature}.
The signals list must be in a table with columns for: signal type (input/output/register) and signal name
```
Signal table can be saved as a csv or txt file such as "Extracted_Signals.csv"


## Step 2: Signal Dependency Map
The following prompt is to create a table that maps the signals of interest to other signals that they are related to.<br>
- Submodule_Spec_Doc: the design or product specification document of the submodule as a .txt or .pdf file. <br>
- sigal_list: an optional file that contains more detailed descriptions of signals (ports, registers, etc.) and their behaviors, state transitions, timing, etc. as a .csv, .txt, .or .pdf file.
- Extracted_Signals: the previously generated table of signals that impact the security feature of interest as a .csv or reference to table if in an active chat session.
- signal: the signal of interest
```bash
[DOC0]   =  {sigal_list}
[DOC1]   =  {Submodule_Spec_Doc}
[TABLE1] =  {Extracted_Signals}
Your response must be bounded from [DOC1], [TABLE1], and any recollection of dependency graphs from computer architecture.
Create a table to show the signals from the design that are related to the signals in [TABLE1].
The table must include columns for signal name and dependent signals.
```

## Step 3: Test Case Generation
The following prompt is to create a table of test cases that test the behavior of the signals that directly impact the selected security feature.<br>

- signal_dependencies: the previously generated table of signals depedencies of the signals that impact the security feature of interest as a .csv or reference to table if in an active chat session.
- Submodule_Spec_Doc: the design or product specification document of the submodule as a .txt or .pdf file. <br>
- sigal_list: an optional file that contains more detailed descriptions of signals (ports, registers, etc.) and their behaviors, state transitions, timing, etc. as a .csv, .txt, .or .pdf file. <br>
- signal: the signal of interest <br>
- security_feature: one security feature from the assessment. <br>
```bash
[DOC0]   =  {sigal_list}
[DOC1]   =  {Submodule_Spec_Doc}
[TABLE2] =  {signal_dependencies}
Your response must be bounded from [DOC0], [DOC1], [TABLE2], and knowledge of defining test cases for a Hardware Verification Test Plan.
Define {security_feature} test cases to demonstrate the timing and behavior of the signals from [TABLE2] that are defined in [DOC0] and [DOC1].
Timing and behavior must be derived from [DOC0] and [DOC1] and not estimated.
The response must be a table that includes: Test case ID, Test name, test case description, stimulus description, and description of the expected behavior
```
It is recommended to list the signals that are expected to be in the test cases after referencing TABLE2 in the prompt statement.
