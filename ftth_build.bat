@REM ########################################################
@REM FTTH_BUILD �r���h�o�b�`
@REM
@REM  Version    �X�V��        �X�V��              ���e
@REM  1.0        2019/11/01    IVS NVHUY          �V�K�쐬
@REM ########################################################

@REM --------------------------------------------------------
@REM ����Eclipse������s���Ă���Subversion(SVN)��ƃR�s�[�̍X�V�`�r���h�܂ł��o�b�`�t�@�C��������B
@REM --------------------------------------------------------

@IF EXIST ftth_build_powershell.ps1 DEL /F ftth_build_powershell.ps1
@IF EXIST winMergeU.bat DEL /F winMergeU.bat
@ECHO OFF
(

@REM ���݂̈ʒu���擾����B
@ECHO $dir = Get-Location
@ECHO $dir = $dir.ToString(^)
@ECHO $nowdate = Get-Date -format "yyyyMMdd"

@REM �N���ݒ�t�@�C��
@ECHO $ftthStartup = "C:\ftth\conf\ftth_startup.conf"
@ECHO if (-Not (test-path $ftthStartup^)^){
@ECHO     throw "C:\ftth\conf\ftth_startup.conf �����݂��܂���B"
@ECHO }
@REM ���ݒ�t�@�C��
@ECHO $ftthDeploy = "C:\ftth\conf\ftth_deploy.conf"
@ECHO if (-Not (test-path $ftthDeploy^)^){
@ECHO     throw "C:\ftth\conf\ftth_deploy.conf �����݂��܂���B"
@ECHO }
@REM �J�����Y�ꗗ.xlsx
@ECHO $kaihatsuShisanList = "C:\ftth\list\"+$nowdate+"\�J�����Y�ꗗ.xlsx"
@ECHO if (-Not (test-path $kaihatsuShisanList^)^){
@ECHO     throw "�J�����Y�ꗗ.xlsx �����݂��܂���B"
@ECHO }

@REM �{�ԋ@�E�i�؋@���擾����B
@ECHO $ftthStartupData = Get-Content $ftthStartup -Encoding UTF8
@ECHO foreach ($line in $ftthStartupData^) {
@ECHO     $locationType = $line
@ECHO     break
@ECHO }

@REM --------------------------------------------------------
@REM �{�ԋ@
@REM --------------------------------------------------------
@ECHO if ($locationType -eq "HONBAN"^){

@REM --------------------------------------------------------
@REM �J�����Y�ꗗ�̎�ނ��uJava�v�̂��̂ɂ��ċL�ڂ���Ă���t�H���_���ɑΉ�����{��SVN�̍�ƃR�s�[���X�V����
@REM --------------------------------------------------------
@REM �J�����Y�ꗗ.xlsx����t�H���_�ꗗ���擾����B
@ECHO     $folderNm = New-Object System.Collections.Generic.List[System.Object]
@ECHO     $xl = New-Object -ComObject Excel.Application
@ECHO     $xl.Visible = $false
@ECHO     $wb = $xl.Workbooks.Open($kaihatsuShisanList^)
@ECHO     $ws = $xl.WorkSheets.Item("�J�����Y�ꗗ"^)
@ECHO     [int]$lastRowvalue = ($ws.UsedRange.rows.count + 1^)-1
@ECHO     for ($i=5; $i -lt $lastRowvalue; $i++^) {
@ECHO         if ($ws.Range("B" + $i^).value2 -eq "java"^){
@ECHO             $folderNm.Add($ws.Range("C" + $i^).value2^)
@ECHO         }
@ECHO     }
@ECHO     $wb.close(^)
@ECHO     $xl.quit(^)

@REM �d���������B
@ECHO     $folderNm = $folderNm ^|^ select -Unique

@REM svn�X�V���s���B
@ECHO     foreach ($svn in $folderNm^) {
@ECHO         if (test-path C:\ftth\workspace\$svn^) {
@ECHO             java -cp "C:\ftth\workspace\ZzSvnUpdateSearcher\jsvn\lib\*" org.tmatesoft.svn.cli.SVN cleanup C:\ftth\workspace\$svn
@ECHO             java -cp "C:\ftth\workspace\ZzSvnUpdateSearcher\jsvn\lib\*" org.tmatesoft.svn.cli.SVN update C:\ftth\workspace\$svn
@ECHO         } else {
@ECHO             throw "C:\ftth\workspace\"+$svn+" �����݂��܂���B"
@ECHO         }
@ECHO     }

@REM --------------------------------------------------------
@REM buid.xml���g����Ant�Ńr���h�����s
@REM --------------------------------------------------------
@ECHO     $ftthDeployData = Get-Content $ftthDeploy -Encoding UTF8
@ECHO     foreach ($line in $ftthDeployData^)
@ECHO     {
@ECHO         $server = $line.split(","^)

@REM �t�H���_���ɑΉ�����buid.xml���g����Ant�Ńr���h�����s
@ECHO         $buildXml = $server.Get(1^)+"\"+$server.Get(3^)
@ECHO         java -jar "C:\ftth\pleiades\eclipse\plugins\org.apache.ant_1.8.2.v20120109-1030\lib\ant-launcher.jar" -buildfile $buildXml
@ECHO     }
@ECHO }

@REM --------------------------------------------------------
@REM �i�؋@
@REM --------------------------------------------------------
@ECHO if ($locationType -eq "QT"^){

@REM --------------------------------------------------------
@REM �J�����Y�ꗗ�̎�ނ��uJava�v�̂��̂ɂ��ċL�ڂ���Ă���t�H���_���ɑΉ�����{��SVN�̍�ƃR�s�[���X�V����
@REM --------------------------------------------------------
@REM �J�����Y�ꗗ.xlsx����t�H���_�ꗗ���擾����B
@ECHO     $folderNm = New-Object System.Collections.Generic.List[System.Object]
@ECHO     $xl = New-Object -ComObject Excel.Application
@ECHO     $xl.Visible = $false
@ECHO     $wb = $xl.Workbooks.Open($kaihatsuShisanList^)
@ECHO     $ws = $xl.WorkSheets.Item("�J�����Y�ꗗ"^)
@ECHO     [int]$lastRowvalue = ($ws.UsedRange.rows.count + 1^)-1
@ECHO     for ($i=5; $i -lt $lastRowvalue; $i++^) {
@ECHO         if ($ws.Range("B" + $i^).value2 -eq "java"^){
@ECHO             $folderNm.Add($ws.Range("C" + $i^).value2^)
@ECHO         }
@ECHO     }
@ECHO     $wb.close(^)
@ECHO     $xl.quit(^)

@REM �d���������B
@ECHO     $folderNm = $folderNm ^|^ select -Unique

@REM svn�X�V���s���B
@ECHO     foreach ($svn in $folderNm^) {
@ECHO         if (test-path C:\ftth\workspace\$svn^) {
@ECHO             java -cp "C:\ftth\workspace\ZzSvnUpdateSearcher\jsvn\lib\*" org.tmatesoft.svn.cli.SVN cleanup C:\ftth\workspace\$svn
@ECHO             java -cp "C:\ftth\workspace\ZzSvnUpdateSearcher\jsvn\lib\*" org.tmatesoft.svn.cli.SVN update C:\ftth\workspace\$svn
@ECHO         } else {
@ECHO             throw "C:\ftth\workspace\"+$svn+" �����݂��܂���B"
@ECHO         }
@ECHO     }

@REM --------------------------------------------------------
@REM �{�ԉ��Ώۃ\�[�X���o�o�b�`�ɋN���ݒ�t�@�C������Y������O��{�ԉ����r�W�����ԍ����Z�b�g���Ď��s����
@REM --------------------------------------------------------
@REM ftth_startup.conf��ǂݍ��ށB
@ECHO     foreach ($line in $ftthStartupData^)
@ECHO     {
@ECHO         if ($line -ne "QT"^){

@REM �f�[�^�𕪊�����B
@ECHO             $projectVersion = $line.split(":"^)

@REM batName�A���݂̃��r�W�������擾����B
@ECHO             $batName = $projectVersion.Get(0^).ToUpper(^) + "_�{�ԉ��Ώۃ\�[�X���o.bat"
@ECHO             $nowRevision = "SET REVISION=" + $projectVersion.Get(1^)

@REM ���r�W������{�ԉ��Ώۃ\�[�X���o�o�b�`�ɐݒ肷��B
@ECHO             $content = Get-Content C:\ftth\workspace\ZzSvnUpdateSearcher\$batName
@ECHO             $content = $content -replace "SET REVISION=[0-9]*", $nowRevision
@ECHO             Set-Content -Value $content C:\ftth\workspace\ZzSvnUpdateSearcher\$batName

@REM �{�ԉ��Ώۃ\�[�X���o�o�b�`�����s����B
@ECHO             cd C:\ftth\workspace\ZzSvnUpdateSearcher\
@ECHO             start $batName
@ECHO             cd $dir
@ECHO         }
@ECHO     }

@REM ���ׂĂ̖{�ԉ��Ώۃ\�[�X���o�o�b�`�̎��s�����܂ő҂B
@ECHO     write-host "----- ���ׂĂ̖{�ԉ��Ώۃ\�[�X���o�o�b�`�̎��s�����܂ő҂� -----"
@ECHO     pause
@ECHO     write-host "���s��..."

@REM --------------------------------------------------------
@REM �o�b�`�t�@�C�����o�͂������O�t�@�C���ƊJ�����Y�ꗗ��˂����킹��
@REM --------------------------------------------------------
@REM �J�����Y�ꗗ.xlsx����fairuList���擾����B
@ECHO     $listExcelCompare = New-Object System.Collections.Generic.List[System.Object]
@ECHO     $xl = New-Object -ComObject Excel.Application
@ECHO     $xl.Visible = $false
@ECHO     $wb = $xl.Workbooks.Open($kaihatsuShisanList^)
@ECHO     $ws = $xl.WorkSheets.Item("�J�����Y�ꗗ"^)
@ECHO     [int]$lastRowvalue = ($ws.UsedRange.rows.count + 1^)-1
@ECHO     for ($i=5; $i -lt $lastRowvalue; $i++^) {
@ECHO         if ($ws.Range("F" + $i^).value2 -ne $null^) {
@ECHO             $listExcelCompare.Add($ws.Range("F" + $i^).value2^)
@ECHO         }
@ECHO     }
@ECHO     $wb.close(^)
@ECHO     $xl.quit(^)

@REM ���O�t�@�C����ǂݍ��ށB
@ECHO     $logDt = Get-Content C:\ftth\workspace\ZzSvnUpdateSearcher\Difference\$nowdate\*.log
@ECHO     $listLogCompare = New-Object System.Collections.Generic.List[System.Object]
@ECHO     $listDiffLink = New-Object System.Collections.Generic.List[System.Object]
@ECHO     $listHonbanLink = New-Object System.Collections.Generic.List[System.Object]
@ECHO     foreach ($line in $logDt^)
@ECHO     {
@ECHO         $listDiffLink.Add($line^)
@ECHO         $honbanLink = "C:\ftth\workspace\" + $line.Substring($line.IndexOf("ftth_"^), $line.length - $line.IndexOf("ftth_"^)^)
@ECHO         $listHonbanLink.Add($honbanLink^)
@ECHO         $sub = $line.split("\"^)
@ECHO         $filename = $sub.Get($sub.Count - 1^)
@ECHO         $listLogCompare.Add($filename^)
@ECHO     }

@REM �J�����Y�ꗗ.xlsx�A���O�t�@�C�����r����B
@ECHO     $missingGroups = Compare-Object $listExcelCompare $listLogCompare
@ECHO     if (!$missingGroups^) {

@REM --------------------------------------------------------
@REM ���o���ꂽ�\�[�X�R�[�h�Ɩ{��SVN�̃\�[�X�R�[�h��diff���擾
@REM --------------------------------------------------------
@ECHO         foreach ($diffLink in $listDiffLink^) {
@ECHO             if ($diffLink -NotMatch "jar"^) {
@ECHO                 $sn1 = $diffLink.Split("\"^)
@ECHO                 $sn2 = $sn1.Get($sn1.Count -1^)
@ECHO                 $sn3 = $sn2.Split("."^)
@ECHO                 $reportName = $sn3.get(0^) + "��r"
@ECHO                 $dt1 = $diffLink
@ECHO                 $dt2 = $listHonbanLink[$listDiffLink.IndexOf($diffLink^)]
@ECHO                 $mergeU = "`"C:\Program Files (x86^)\WinMerge\WinMergeU.exe`"" + " " + "`"$dt1`"" + " " + "`"$dt2`"" + " -minimize -noninteractive -u -or " + "`"$dir\$reportName.html`""
@ECHO                 Add-Content -Value $mergeU $dir\winMergeU.bat
@ECHO             }
@ECHO         }
@ECHO         Add-Content -Value "del /f winMergeU.bat" $dir\winMergeU.bat
@ECHO         start $dir\winMergeU.bat -windowstyle hidden

@REM ���o���ꂽ�\�[�X�R�[�h�Ɩ{��SVN�̃\�[�X�R�[�h��diff���擾
@ECHO         write-host "���o���ꂽ�\�[�X�R�[�h�Ɩ{��SVN�̃\�[�X�R�[�h�ɍ��ق�����܂��B�\�[�X�R�[�h��Diff�����m�F���������B"

@REM --------------------------------------------------------
@REM ���o���ꂽ�\�[�X�R�[�h�����[�N�X�y�[�X�ɃR�s�[����B
@REM --------------------------------------------------------
@ECHO         $dt = Get-Content $ftthDeploy -Encoding UTF8
@ECHO         $buildList = New-Object System.Collections.Generic.List[System.Object]
@ECHO         foreach ($line in $dt^)
@ECHO         {
@ECHO             $server = $line.split(","^)

@REM ���o���ꂽ�\�[�X�R�[�h�����[�N�X�y�[�X�ɃR�s�[����
@ECHO             $honban = $server.Get(1^)
@ECHO             $dev = $server.Get(2^) + "\trunk\source\" + $server.Get(0^)
@ECHO             Copy-Item -Path $dev\* -Destination $honban -recurse -Forc

@REM buid.xml���g����Ant�Ńr���h�����s
@ECHO             $buildXml = $server.Get(1^)+"\"+$server.Get(3^)
@ECHO             java -jar "C:\ftth\pleiades\eclipse\plugins\org.apache.ant_1.8.2.v20120109-1030\lib\ant-launcher.jar" -buildfile $buildXml
@ECHO         }
@ECHO     } else {

@REM �`�F�b�N����.txt���������ށB
@ECHO         Add-Content -Value "�@�s���t�@�C��(�J�����Y�ꗗ�ɂ��邪�ASVN�����ɂȂ��j" $dir"\�`�F�b�N����.txt"
@ECHO         foreach ($miss in $missingGroups^){
@ECHO             if ($miss.SideIndicator -eq "<="^) {
@ECHO                 Add-Content -Value $miss.InputObject $dir"\�`�F�b�N����.txt"
@ECHO             }
@ECHO         }
@ECHO         Add-Content -Value "�A�]��t�@�C��(�J�����Y�ꗗ�ɂȂ����ASVN�����ɂ���j" $dir"\�`�F�b�N����.txt"
@ECHO         foreach ($miss in $missingGroups^){
@ECHO             if ($miss.SideIndicator -eq "=>"^) {
@ECHO                 Add-Content -Value $miss.InputObject $dir"\�`�F�b�N����.txt"
@ECHO             }
@ECHO         }

@REM �s��v�ł���΃`�F�b�N���ʂɍ������o���Ĉُ�I��������
@ECHO     write-host "�J�����Y�ꗗ.xlsx �ƃ��O�t�@�C���ɍ��ق�����܂��B�`�F�b�N���ʂ����m�F���������B"
@ECHO     }
@ECHO }
@ECHO Remove-Item ftth_build_powershell.ps1
)>>ftth_build_powershell.ps1
@ECHO ON

PowerShell.exe -ExecutionPolicy UnRestricted -File ftth_build_powershell.ps1
@PAUSE