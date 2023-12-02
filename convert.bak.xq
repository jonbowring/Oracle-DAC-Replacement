xquery version "3.0";

let $tprops := <props>
  <id>aJDWwb7VFSmbzZ86glzi99</id>
  <name>tf_Example</name>
</props>

let $plans := doc('in/plans.xml')
let $steps := $plans//Q{}row[1] (:  TODO remove index filter :)
let $order := for $item in distinct-values($steps//Q{}plan_step_order)
                order by $item
                return $item

let $tflow := <aetgt:getResponse xmlns:aetgt="http://schemas.active-endpoints.com/appmodules/repository/2010/10/avrepository.xsd"
                   xmlns:types1="http://schemas.active-endpoints.com/appmodules/repository/2010/10/avrepository.xsd">
   <types1:Item>
      <types1:EntryId>3RKWa-gt-522578-2023-12-01T22:58:53.881Z::tf.xml</types1:EntryId>
      <types1:Name>{ $tprops/name/text() }</types1:Name>
      <types1:MimeType>application/xml+taskflow</types1:MimeType>
      <types1:Description/>
      <types1:AppliesTo/>
      <types1:Tags/>
      <types1:VersionLabel>1.0</types1:VersionLabel>
      <types1:State>CURRENT</types1:State>
      <types1:ProcessGroup/>
      <types1:CreatedBy>jbowring_APJS_tspod_SO</types1:CreatedBy>
      <types1:CreationDate>2023-12-01T22:58:54Z</types1:CreationDate>
      <types1:ModifiedBy/>
      <types1:PublicationStatus>unpublished</types1:PublicationStatus>
      <types1:AutosaveExists>false</types1:AutosaveExists>
      <types1:Entry>
         <taskflow xmlns="http://schemas.active-endpoints.com/appmodules/screenflow/2010/10/avosScreenflow.xsd"
                   xmlns:tfm="http://schemas.active-endpoints.com/appmodules/screenflow/2021/04/taskflowModel.xsd"
                   xmlns:list="urn:activevos:spi:list:functions"
                   displayName="{ $tprops/name/text() }"
                   name="{ $tprops/name/text() }"
                   overrideAPIName="false">
            <parameterSet xmlns="http://schemas.active-endpoints.com/appmodules/screenflow/2021/04/taskflowModel.xsd"/>
            <appliesTo/>
            <description/>
            <tags/>
            <generator>Informatica Process Designer 11</generator>
            
            <tempFields>
               {
                  for $step in $steps
                    return <field description="" name="{data($step/Q{}step_name)}" type="reference">
                      <options>
                        <option name="failOnNotRun">false</option>
                        <option name="failOnFault">false</option>
                        <option name="referenceTo">$po:mt-Example</option> <!-- TODO Must use the following format with [^a-zA-Z0-9] replaced with minus: $po:{{mapping task name}} -->
                      </options>
                  </field>
                }
            </tempFields>
            <notes/>
            <deployment skipIfRunning="false" suspendOnFault="false" tracingLevel="verbose">
               <rest/>
            </deployment>
            <flow id="a">
               <start id="start">
                  <link id="startLink" targetId="step0"/>
               </start>

               <!-- Start of first step in the flow -->
                {
                  for $seq in $order
                    let $seqCount := count($steps[Q{}plan_step_order = $seq])
                    let $container := if($seqCount = 1) then (
                          let $step := $steps[Q{}plan_step_order = $seq]
                          let $mtID := '1jY0fuy0iEUhkrHVLx78WK'
                          
                          return <eventContainer id="step{$seq}">
                            <service id="service{$seq}">
                              <title>{$step/Q{}step_name/text()}</title>
                              <serviceName>ICSExecuteDataTask</serviceName>
                              <serviceGUID/>
                              <serviceInput>
                                  <parameter name="Wait for Task to Complete" source="constant" updatable="true">true</parameter>
                                  <parameter name="Max Wait" source="constant" updatable="true">604800</parameter>
                                  <parameter name="Task Name" source="constant" updatable="true">mt_Example</parameter>
                                  <parameter name="GUID" source="constant" updatable="true">{ $mtID }</parameter>
                                  <parameter name="Task Type" source="constant" updatable="true">MCT</parameter>
                                  <parameter name="Has Inout Parameters" source="constant" updatable="true">false</parameter>
                                  <parameter name="taskField" source="nested">
                                    <operation source="field" to="mt-Example">temp.{$step/Q{}step_name/text()}</operation>
                                  </parameter>
                              </serviceInput>
                              <serviceOutput>
                                  <operation source="field" to="temp.{$step/Q{}step_name/text()}/output/Object_Name">Object Name</operation>
                                  <operation source="field" to="temp.{$step/Q{}step_name/text()}/output/Run_Id">Run Id</operation>
                                  <operation source="field" to="temp.{$step/Q{}step_name/text()}/output/Log_Id">Log Id</operation>
                                  <operation source="field" to="temp.Data Task 1/output/Task_Id">Task Id</operation>
                                  <operation source="field" to="temp.{$step/Q{}step_name/text()}/output/Task_Status">Task Status</operation>
                                  <operation source="field" to="temp.{$step/Q{}step_name/text()}/output/Success_Source_Rows">Success Source Rows</operation>
                                  <operation source="field" to="temp.{$step/Q{}step_name/text()}/output/Failed_Source_Rows">Failed Source Rows</operation>
                                  <operation source="field" to="temp.{$step/Q{}step_name/text()}/output/Success_Target_Rows">Success Target Rows</operation>
                                  <operation source="field" to="temp.{$step/Q{}step_name/text()}/output/Failed_Target_Rows">Failed Target Rows</operation>
                                  <operation source="field" to="temp.{$step/Q{}step_name/text()}/output/Start_Time">Start Time</operation>
                                  <operation source="field" to="temp.{$step/Q{}step_name/text()}/output/End_Time">End Time</operation>
                                  <operation source="field" to="temp.{$step/Q{}step_name/text()}/output/Error_Message">Error Message</operation>
                                  <operation source="field" to="temp.{$step/Q{}step_name/text()}/output/TotalTransErrors">Total Transformation Errors</operation>
                                  <operation source="field" to="temp.{$step/Q{}step_name/text()}/output/FirstErrorCode">First Error Code</operation>
                              </serviceOutput>
                            </service>
                            <link id="step{$seq}Link" targetId="end"/>
                            <events>
                              <catch faultField="temp.{$step/Q{}step_name/text()}/fault"
                                      id="step{$seq}FaultError"
                                      interrupting="true"
                                      name="error">
                                  <suspend/>
                              </catch>
                              <catch faultField="temp.{$step/Q{}step_name/text()}/fault"
                                      id="step{$seq}FaultWarning"
                                      interrupting="true"
                                      name="warning"/>
                            </events>
                        </eventContainer>
                    ) else (
                      <foo/> (: TODO add parallel processing container:)
                    )
                    return $container
                }

               <end id="end"/>
            </flow>
            <dependencies>
               <processObject xmlns="http://schemas.active-endpoints.com/appmodules/screenflow/2011/06/avosHostEnvironment.xsd"
                              displayName="mt-Example"
                              isByCopy="true"
                              name="mt-Example"> <!-- TODO update mapping name -->
                  <description/>
                  <tags/>
                  <detail>
                     <field label="TaskProperties Parameters"
                            name="taskProperties"
                            nullable="true"
                            required="false"
                            type="reference"/>
                     <field label="Output Parameters"
                            name="output"
                            nullable="true"
                            required="false"
                            type="reference"/>
                     <field label="Fault"
                            name="fault"
                            nullable="true"
                            required="false"
                            type="reference"/>
                     <field label="Max Wait (Seconds)"
                            name="Max_Wait"
                            nullable="true"
                            required="false"
                            type="int"/>
                  </detail>
               </processObject>
            </dependencies>
         </taskflow>
      </types1:Entry>
      <types1:GUID>{ $tprops/id/text() }</types1:GUID>
      <types1:DisplayName>{ $tprops/name/text() }</types1:DisplayName>
   </types1:Item>
   <types1:CurrentServerDateTime>2023-12-01T22:59:59.17Z</types1:CurrentServerDateTime>
</aetgt:getResponse>

return $tflow