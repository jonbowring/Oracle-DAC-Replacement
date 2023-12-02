java -Xmx14000M -cp ../saxon-he-10.5.jar net.sf.saxon.Query -q:convert.xq -o:out/Explore/Default/tf_Example.TASKFLOW.xml
$hash = (Get-FileHash -Algorithm SHA256 "out/Explore/Default/tf_Example.TASKFLOW.xml").Hash
(Get-Content "out/exportPackage.chksum") -replace '(^Explore/Default/tf_Example\.TASKFLOW\.xml=).*$', "`${1}$hash" | Set-Content "out/exportPackage.chksum"
tar -acf import.zip -C out *