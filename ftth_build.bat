@REM ########################################################
@REM FTTH_BUILD ビルドバッチ
@REM
@REM  Version    更新日        更新者              内容
@REM  1.0        2019/11/01    IVS NVHUY          新規作成
@REM ########################################################

@REM --------------------------------------------------------
@REM 現在Eclipseから実行しているSubversion(SVN)作業コピーの更新～ビルドまでをバッチファイル化する。
@REM --------------------------------------------------------

@IF EXIST ftth_build_powershell.ps1 DEL /F ftth_build_powershell.ps1
@IF EXIST winMergeU.bat DEL /F winMergeU.bat
@ECHO OFF
(

@REM 現在の位置を取得する。
@ECHO $dir = Get-Location
@ECHO $dir = $dir.ToString(^)
@ECHO $nowdate = Get-Date -format "yyyyMMdd"

@REM 起動設定ファイル
@ECHO $ftthStartup = "C:\ftth\conf\ftth_startup.conf"
@ECHO if (-Not (test-path $ftthStartup^)^){
@ECHO     throw "C:\ftth\conf\ftth_startup.conf が存在しません。"
@ECHO }
@REM 環境設定ファイル
@ECHO $ftthDeploy = "C:\ftth\conf\ftth_deploy.conf"
@ECHO if (-Not (test-path $ftthDeploy^)^){
@ECHO     throw "C:\ftth\conf\ftth_deploy.conf が存在しません。"
@ECHO }
@REM 開発資産一覧.xlsx
@ECHO $kaihatsuShisanList = "C:\ftth\list\"+$nowdate+"\開発資産一覧.xlsx"
@ECHO if (-Not (test-path $kaihatsuShisanList^)^){
@ECHO     throw "開発資産一覧.xlsx が存在しません。"
@ECHO }

@REM 本番機・品証機を取得する。
@ECHO $ftthStartupData = Get-Content $ftthStartup -Encoding UTF8
@ECHO foreach ($line in $ftthStartupData^) {
@ECHO     $locationType = $line
@ECHO     break
@ECHO }

@REM --------------------------------------------------------
@REM 本番機
@REM --------------------------------------------------------
@ECHO if ($locationType -eq "HONBAN"^){

@REM --------------------------------------------------------
@REM 開発資産一覧の種類が「Java」のものについて記載されているフォルダ名に対応する本番SVNの作業コピーを更新する
@REM --------------------------------------------------------
@REM 開発資産一覧.xlsxからフォルダ一覧を取得する。
@ECHO     $folderNm = New-Object System.Collections.Generic.List[System.Object]
@ECHO     $xl = New-Object -ComObject Excel.Application
@ECHO     $xl.Visible = $false
@ECHO     $wb = $xl.Workbooks.Open($kaihatsuShisanList^)
@ECHO     $ws = $xl.WorkSheets.Item("開発資産一覧"^)
@ECHO     [int]$lastRowvalue = ($ws.UsedRange.rows.count + 1^)-1
@ECHO     for ($i=5; $i -lt $lastRowvalue; $i++^) {
@ECHO         if ($ws.Range("B" + $i^).value2 -eq "java"^){
@ECHO             $folderNm.Add($ws.Range("C" + $i^).value2^)
@ECHO         }
@ECHO     }
@ECHO     $wb.close(^)
@ECHO     $xl.quit(^)

@REM 重複を消す。
@ECHO     $folderNm = $folderNm ^|^ select -Unique

@REM svn更新を行う。
@ECHO     foreach ($svn in $folderNm^) {
@ECHO         if (test-path C:\ftth\workspace\$svn^) {
@ECHO             java -cp "C:\ftth\workspace\ZzSvnUpdateSearcher\jsvn\lib\*" org.tmatesoft.svn.cli.SVN cleanup C:\ftth\workspace\$svn
@ECHO             java -cp "C:\ftth\workspace\ZzSvnUpdateSearcher\jsvn\lib\*" org.tmatesoft.svn.cli.SVN update C:\ftth\workspace\$svn
@ECHO         } else {
@ECHO             throw "C:\ftth\workspace\"+$svn+" が存在しません。"
@ECHO         }
@ECHO     }

@REM --------------------------------------------------------
@REM buid.xmlを使ってAntでビルドを実行
@REM --------------------------------------------------------
@ECHO     $ftthDeployData = Get-Content $ftthDeploy -Encoding UTF8
@ECHO     foreach ($line in $ftthDeployData^)
@ECHO     {
@ECHO         $server = $line.split(","^)

@REM フォルダ名に対応するbuid.xmlを使ってAntでビルドを実行
@ECHO         $buildXml = $server.Get(1^)+"\"+$server.Get(3^)
@ECHO         java -jar "C:\ftth\pleiades\eclipse\plugins\org.apache.ant_1.8.2.v20120109-1030\lib\ant-launcher.jar" -buildfile $buildXml
@ECHO     }
@ECHO }

@REM --------------------------------------------------------
@REM 品証機
@REM --------------------------------------------------------
@ECHO if ($locationType -eq "QT"^){

@REM --------------------------------------------------------
@REM 開発資産一覧の種類が「Java」のものについて記載されているフォルダ名に対応する本番SVNの作業コピーを更新する
@REM --------------------------------------------------------
@REM 開発資産一覧.xlsxからフォルダ一覧を取得する。
@ECHO     $folderNm = New-Object System.Collections.Generic.List[System.Object]
@ECHO     $xl = New-Object -ComObject Excel.Application
@ECHO     $xl.Visible = $false
@ECHO     $wb = $xl.Workbooks.Open($kaihatsuShisanList^)
@ECHO     $ws = $xl.WorkSheets.Item("開発資産一覧"^)
@ECHO     [int]$lastRowvalue = ($ws.UsedRange.rows.count + 1^)-1
@ECHO     for ($i=5; $i -lt $lastRowvalue; $i++^) {
@ECHO         if ($ws.Range("B" + $i^).value2 -eq "java"^){
@ECHO             $folderNm.Add($ws.Range("C" + $i^).value2^)
@ECHO         }
@ECHO     }
@ECHO     $wb.close(^)
@ECHO     $xl.quit(^)

@REM 重複を消す。
@ECHO     $folderNm = $folderNm ^|^ select -Unique

@REM svn更新を行う。
@ECHO     foreach ($svn in $folderNm^) {
@ECHO         if (test-path C:\ftth\workspace\$svn^) {
@ECHO             java -cp "C:\ftth\workspace\ZzSvnUpdateSearcher\jsvn\lib\*" org.tmatesoft.svn.cli.SVN cleanup C:\ftth\workspace\$svn
@ECHO             java -cp "C:\ftth\workspace\ZzSvnUpdateSearcher\jsvn\lib\*" org.tmatesoft.svn.cli.SVN update C:\ftth\workspace\$svn
@ECHO         } else {
@ECHO             throw "C:\ftth\workspace\"+$svn+" が存在しません。"
@ECHO         }
@ECHO     }

@REM --------------------------------------------------------
@REM 本番化対象ソース抽出バッチに起動設定ファイルから該当する前回本番化リビジョン番号をセットして実行する
@REM --------------------------------------------------------
@REM ftth_startup.confを読み込む。
@ECHO     foreach ($line in $ftthStartupData^)
@ECHO     {
@ECHO         if ($line -ne "QT"^){

@REM データを分割する。
@ECHO             $projectVersion = $line.split(":"^)

@REM batName、現在のリビジョンを取得する。
@ECHO             $batName = $projectVersion.Get(0^).ToUpper(^) + "_本番化対象ソース抽出.bat"
@ECHO             $nowRevision = "SET REVISION=" + $projectVersion.Get(1^)

@REM リビジョンを本番化対象ソース抽出バッチに設定する。
@ECHO             $content = Get-Content C:\ftth\workspace\ZzSvnUpdateSearcher\$batName
@ECHO             $content = $content -replace "SET REVISION=[0-9]*", $nowRevision
@ECHO             Set-Content -Value $content C:\ftth\workspace\ZzSvnUpdateSearcher\$batName

@REM 本番化対象ソース抽出バッチを実行する。
@ECHO             cd C:\ftth\workspace\ZzSvnUpdateSearcher\
@ECHO             start $batName
@ECHO             cd $dir
@ECHO         }
@ECHO     }

@REM すべての本番化対象ソース抽出バッチの実行完了まで待つ。
@ECHO     write-host "----- すべての本番化対象ソース抽出バッチの実行完了まで待つ -----"
@ECHO     pause
@ECHO     write-host "実行中..."

@REM --------------------------------------------------------
@REM バッチファイルが出力したログファイルと開発資産一覧を突き合わせる
@REM --------------------------------------------------------
@REM 開発資産一覧.xlsxからfairuListを取得する。
@ECHO     $listExcelCompare = New-Object System.Collections.Generic.List[System.Object]
@ECHO     $xl = New-Object -ComObject Excel.Application
@ECHO     $xl.Visible = $false
@ECHO     $wb = $xl.Workbooks.Open($kaihatsuShisanList^)
@ECHO     $ws = $xl.WorkSheets.Item("開発資産一覧"^)
@ECHO     [int]$lastRowvalue = ($ws.UsedRange.rows.count + 1^)-1
@ECHO     for ($i=5; $i -lt $lastRowvalue; $i++^) {
@ECHO         if ($ws.Range("F" + $i^).value2 -ne $null^) {
@ECHO             $listExcelCompare.Add($ws.Range("F" + $i^).value2^)
@ECHO         }
@ECHO     }
@ECHO     $wb.close(^)
@ECHO     $xl.quit(^)

@REM ログファイルを読み込む。
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

@REM 開発資産一覧.xlsx、ログファイルを比較する。
@ECHO     $missingGroups = Compare-Object $listExcelCompare $listLogCompare
@ECHO     if (!$missingGroups^) {

@REM --------------------------------------------------------
@REM 抽出されたソースコードと本番SVNのソースコードのdiffを取得
@REM --------------------------------------------------------
@ECHO         foreach ($diffLink in $listDiffLink^) {
@ECHO             if ($diffLink -NotMatch "jar"^) {
@ECHO                 $sn1 = $diffLink.Split("\"^)
@ECHO                 $sn2 = $sn1.Get($sn1.Count -1^)
@ECHO                 $sn3 = $sn2.Split("."^)
@ECHO                 $reportName = $sn3.get(0^) + "比較"
@ECHO                 $dt1 = $diffLink
@ECHO                 $dt2 = $listHonbanLink[$listDiffLink.IndexOf($diffLink^)]
@ECHO                 $mergeU = "`"C:\Program Files (x86^)\WinMerge\WinMergeU.exe`"" + " " + "`"$dt1`"" + " " + "`"$dt2`"" + " -minimize -noninteractive -u -or " + "`"$dir\$reportName.html`""
@ECHO                 Add-Content -Value $mergeU $dir\winMergeU.bat
@ECHO             }
@ECHO         }
@ECHO         Add-Content -Value "del /f winMergeU.bat" $dir\winMergeU.bat
@ECHO         start $dir\winMergeU.bat -windowstyle hidden

@REM 抽出されたソースコードと本番SVNのソースコードのdiffを取得
@ECHO         write-host "抽出されたソースコードと本番SVNのソースコードに差異があります。ソースコードのDiffをご確認ください。"

@REM --------------------------------------------------------
@REM 抽出されたソースコードをワークスペースにコピーする。
@REM --------------------------------------------------------
@ECHO         $dt = Get-Content $ftthDeploy -Encoding UTF8
@ECHO         $buildList = New-Object System.Collections.Generic.List[System.Object]
@ECHO         foreach ($line in $dt^)
@ECHO         {
@ECHO             $server = $line.split(","^)

@REM 抽出されたソースコードをワークスペースにコピーする
@ECHO             $honban = $server.Get(1^)
@ECHO             $dev = $server.Get(2^) + "\trunk\source\" + $server.Get(0^)
@ECHO             Copy-Item -Path $dev\* -Destination $honban -recurse -Forc

@REM buid.xmlを使ってAntでビルドを実行
@ECHO             $buildXml = $server.Get(1^)+"\"+$server.Get(3^)
@ECHO             java -jar "C:\ftth\pleiades\eclipse\plugins\org.apache.ant_1.8.2.v20120109-1030\lib\ant-launcher.jar" -buildfile $buildXml
@ECHO         }
@ECHO     } else {

@REM チェック結果.txtを書き込む。
@ECHO         Add-Content -Value "①不足ファイル(開発資産一覧にあるが、SVN差分にない）" $dir"\チェック結果.txt"
@ECHO         foreach ($miss in $missingGroups^){
@ECHO             if ($miss.SideIndicator -eq "<="^) {
@ECHO                 Add-Content -Value $miss.InputObject $dir"\チェック結果.txt"
@ECHO             }
@ECHO         }
@ECHO         Add-Content -Value "②余剰ファイル(開発資産一覧にないが、SVN差分にある）" $dir"\チェック結果.txt"
@ECHO         foreach ($miss in $missingGroups^){
@ECHO             if ($miss.SideIndicator -eq "=>"^) {
@ECHO                 Add-Content -Value $miss.InputObject $dir"\チェック結果.txt"
@ECHO             }
@ECHO         }

@REM 不一致であればチェック結果に差分を出して異常終了させる
@ECHO     write-host "開発資産一覧.xlsx とログファイルに差異があります。チェック結果をご確認ください。"
@ECHO     }
@ECHO }
@ECHO Remove-Item ftth_build_powershell.ps1
)>>ftth_build_powershell.ps1
@ECHO ON

PowerShell.exe -ExecutionPolicy UnRestricted -File ftth_build_powershell.ps1
@PAUSE