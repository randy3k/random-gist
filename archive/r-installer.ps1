If ('${{ matrix.r }}' -eq 'latest') {
  (new-object net.webclient).DownloadString("http://cran.rstudio.com/bin/windows/base/") -match 'href="(R-[0-9.]*[a-zA-Z]*-win.exe)"';
  (new-object net.webclient).DownloadFile($("http://cran.rstudio.com/bin/windows/base/"+$matches[1]),"C:\R-binary.exe")
} ElseIf ('${{ matrix.r }}' -eq 'devel') {
  (new-object net.webclient).DownloadFile("https://cran.r-project.org/bin/windows/base/R-devel-win.exe","C:\R-binary.exe")
} Else {
  (new-object net.webclient).DownloadString("http://cran.rstudio.com/bin/windows/base/old/") -match 'R (${{ matrix.r }}[\\.0-9]*)</a>'
  (new-object net.webclient).DownloadFile($("https://cran.r-project.org/bin/windows/base/old/"+$matches[1]+"/R-"+$matches[1]+"-win.exe"),"C:\R-binary.exe")
}
(new-object net.webclient).DownloadFile("https://cran.r-project.org/bin/windows/Rtools/Rtools35.exe","C:\Rtools35.exe")

Start-Process -FilePath "C:\R-binary.exe" -Wait -ArgumentList "/VERYSILENT /DIR=C:\R"
Start-Process -FilePath "C:\Rtools35.exe" -Wait -ArgumentList "/VERYSILENT"
