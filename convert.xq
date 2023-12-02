xquery version "3.0";

import module namespace jb = 'http://informatica.com' at 'functions.xq';
declare option saxon:output "omit-xml-declaration=yes";

let $tprops := <props>
  <id>aJDWwb7VFSmbzZ86glzi99</id>
  <name>tf_Example</name>
</props>

let $plans := doc('in/plans.xml')
let $steps := $plans//Q{}row[Q{}plan_step_order = 0] (:  TODO remove index filter :)
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
                    let $tasks := $steps[Q{}plan_step_order = $seq]
                    let $taskID := '1jY0fuy0iEUhkrHVLx78WK' (: TODO using actual mapping task ID:)
                    let $container := if($seqCount = 1) then (
                          jb:addContainer($seq, $taskID, 'end', $tasks[1]) (: TODO update next link :)
                    ) else (
                          jb:addParallels($seq, $taskID, 'end', $tasks) (: TODO update next link :)
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