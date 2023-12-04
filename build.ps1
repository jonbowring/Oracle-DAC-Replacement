java -Xmx14000M -cp ../saxon-he-10.5.jar net.sf.saxon.Query -q:convert.xq -o:out/Explore/Default/Echo_Employee_Snapshot_Oracle_R12_1_3.TASKFLOW.xml tname=Echo_Employee_Snapshot_Oracle_R12_1_3.TASKFLOW.xml tflowid=75675739549648d18f41355c68e32dbb
$hash = (Get-FileHash -Algorithm SHA256 "out/Explore/Default/Echo_Employee_Snapshot_Oracle_R12_1_3.TASKFLOW.xml").Hash
(Get-Content "out/exportPackage.chksum") -replace '(^Explore/Default/Echo_Employee_Snapshot_Oracle_R12_1_3.TASKFLOW.xml\.TASKFLOW\.xml=).*$', "`${1}$hash" | Set-Content "out/exportPackage.chksum"
tar -acf import.zip -C out *