xquery version "3.0";

module namespace jb="http://informatica.com";

declare function jb:getNextStep($i as xs:integer?, $order as xs:anyAtomicType*) as xs:string {
    let $len := count($order)
    let $next := $i + 1
    let $step := if($next > $len) then ('end') else ('step' || xs:string($order[$next]))
    return $step
};

declare function jb:addContainer($seq as xs:integer, $taskID as xs:string, $nextID as xs:string, $task as node()*) as node()* {
  let $container := <eventContainer xmlns="http://schemas.active-endpoints.com/appmodules/screenflow/2010/10/avosScreenflow.xsd" id="step{$seq}">
    <service id="service{$seq}">
      <title>{$task/Q{}step_name/text()}</title>
      <serviceName>ICSExecuteDataTask</serviceName>
      <serviceGUID/>
      <serviceInput>
          <parameter name="Wait for Task to Complete" source="constant" updatable="true">true</parameter>
          <parameter name="Max Wait" source="constant" updatable="true">604800</parameter>
          <parameter name="Task Name" source="constant" updatable="true">mt_Example</parameter><!-- TODO Update dynamically -->
          <parameter name="GUID" source="constant" updatable="true">{ $taskID }</parameter>
          <parameter name="Task Type" source="constant" updatable="true">MCT</parameter>
          <parameter name="Has Inout Parameters" source="constant" updatable="true">false</parameter>
          <parameter name="taskField" source="nested">
            <operation source="field" to="mt-Example">temp.{$task/Q{}step_name/text()}</operation>
          </parameter>
      </serviceInput>
      <serviceOutput>
          <operation source="field" to="temp.{$task/Q{}step_name/text()}/output/Object_Name">Object Name</operation>
          <operation source="field" to="temp.{$task/Q{}step_name/text()}/output/Run_Id">Run Id</operation>
          <operation source="field" to="temp.{$task/Q{}step_name/text()}/output/Log_Id">Log Id</operation>
          <operation source="field" to="temp.{$task/Q{}step_name/text()}/output/Task_Id">Task Id</operation>
          <operation source="field" to="temp.{$task/Q{}step_name/text()}/output/Task_Status">Task Status</operation>
          <operation source="field" to="temp.{$task/Q{}step_name/text()}/output/Success_Source_Rows">Success Source Rows</operation>
          <operation source="field" to="temp.{$task/Q{}step_name/text()}/output/Failed_Source_Rows">Failed Source Rows</operation>
          <operation source="field" to="temp.{$task/Q{}step_name/text()}/output/Success_Target_Rows">Success Target Rows</operation>
          <operation source="field" to="temp.{$task/Q{}step_name/text()}/output/Failed_Target_Rows">Failed Target Rows</operation>
          <operation source="field" to="temp.{$task/Q{}step_name/text()}/output/Start_Time">Start Time</operation>
          <operation source="field" to="temp.{$task/Q{}step_name/text()}/output/End_Time">End Time</operation>
          <operation source="field" to="temp.{$task/Q{}step_name/text()}/output/Error_Message">Error Message</operation>
          <operation source="field" to="temp.{$task/Q{}step_name/text()}/output/TotalTransErrors">Total Transformation Errors</operation>
          <operation source="field" to="temp.{$task/Q{}step_name/text()}/output/FirstErrorCode">First Error Code</operation>
      </serviceOutput>
    </service>
    <link id="step{$seq}Link" targetId="{$nextID}"/>
    <events>
      <catch faultField="temp.{$task/Q{}step_name/text()}/fault"
              id="step{$seq}FaultError"
              interrupting="true"
              name="error">
          <suspend/>
      </catch>
      <catch faultField="temp.{$task/Q{}step_name/text()}/fault"
              id="step{$seq}FaultWarning"
              interrupting="true"
              name="warning"/>
    </events>
  </eventContainer>

  return $container
};

declare function jb:addParallels($seq as xs:integer, $taskID as xs:string, $nextID as xs:string, $tasks as node()*) as node()* {
    let $container := <container xmlns="http://schemas.active-endpoints.com/appmodules/screenflow/2010/10/avosScreenflow.xsd" id="step{$seq}" type="parallel">
        <title>Parallel Paths 1</title>
        {
            for $task at $i in $tasks
                let $flow := <flow id="par{$seq}flow{$i}">
                                <eventContainer id="par{$seq}step{$i}">
                                <service id="par{$seq}service{$i}">
                                    <title>{$task/Q{}step_name/text()}</title>
                                    <serviceName>ICSExecuteDataTask</serviceName>
                                    <serviceGUID/>
                                    <serviceInput>
                                        <parameter name="Wait for Task to Complete" source="constant" updatable="true">true</parameter>
                                        <parameter name="Max Wait" source="constant" updatable="true">604800</parameter>
                                        <parameter name="Task Name" source="constant" updatable="true">mt_Example</parameter><!-- TODO Update dynamically -->
                                        <parameter name="GUID" source="constant" updatable="true">{ $taskID }</parameter>
                                        <parameter name="Task Type" source="constant" updatable="true">MCT</parameter>
                                        <parameter name="Has Inout Parameters" source="constant" updatable="true">false</parameter>
                                        <parameter name="taskField" source="nested">
                                            <operation source="field" to="mt-Example">temp.{$task/Q{}step_name/text()}</operation>
                                        </parameter>
                                    </serviceInput>
                                    <serviceOutput>
                                        <operation source="field" to="temp.{$task/Q{}step_name/text()}/output/Object_Name">Object Name</operation>
                                        <operation source="field" to="temp.{$task/Q{}step_name/text()}/output/Run_Id">Run Id</operation>
                                        <operation source="field" to="temp.{$task/Q{}step_name/text()}/output/Log_Id">Log Id</operation>
                                        <operation source="field" to="temp.{$task/Q{}step_name/text()}/output/Task_Id">Task Id</operation>
                                        <operation source="field" to="temp.{$task/Q{}step_name/text()}/output/Task_Status">Task Status</operation>
                                        <operation source="field" to="temp.{$task/Q{}step_name/text()}/output/Success_Source_Rows">Success Source Rows</operation>
                                        <operation source="field" to="temp.{$task/Q{}step_name/text()}/output/Failed_Source_Rows">Failed Source Rows</operation>
                                        <operation source="field" to="temp.{$task/Q{}step_name/text()}/output/Success_Target_Rows">Success Target Rows</operation>
                                        <operation source="field" to="temp.{$task/Q{}step_name/text()}/output/Failed_Target_Rows">Failed Target Rows</operation>
                                        <operation source="field" to="temp.{$task/Q{}step_name/text()}/output/Start_Time">Start Time</operation>
                                        <operation source="field" to="temp.{$task/Q{}step_name/text()}/output/End_Time">End Time</operation>
                                        <operation source="field" to="temp.{$task/Q{}step_name/text()}/output/Error_Message">Error Message</operation>
                                        <operation source="field" to="temp.{$task/Q{}step_name/text()}/output/TotalTransErrors">Total Transformation Errors</operation>
                                        <operation source="field" to="temp.{$task/Q{}step_name/text()}/output/FirstErrorCode">First Error Code</operation>
                                    </serviceOutput>
                                </service>
                                <events>
                                    <catch faultField="temp.{$task/Q{}step_name/text()}/fault"
                                            id="step{$seq}FaultError{$i}"
                                            interrupting="true"
                                            name="error">
                                        <suspend/>
                                    </catch>
                                    <catch faultField="temp.{$task/Q{}step_name/text()}/fault"
                                            id="step{$seq}FaultWarning{$i}"
                                            interrupting="true"
                                            name="warning"/>
                                </events>
                                </eventContainer>
                                <link id="par{$seq}flow{$i}link" targetId="step{$seq}" type="containerLink"/>
                            </flow>

                            return $flow
        }
        
        {
            for $task at $i in $tasks
                return <link id="par{$seq}flow{$i}link{$i}" targetId="par{$seq}flow{$i}" type="containerLink"/>
        }
        
        <link id="par{$seq}link" targetId="{$nextID}"/>
    </container>

    return $container
};