Add-Type -AssemblyName System.Windows.Forms

$form = New-Object System.Windows.Forms.Form
$form.Text = "IntelliPen Deployment"
$form.Size = New-Object System.Drawing.Size(800, 850)
$form.StartPosition = "CenterScreen"

# Create TabControl
$tabControl = New-Object System.Windows.Forms.TabControl
$tabControl.Dock = [System.Windows.Forms.DockStyle]::Fill
$form.Controls.Add($tabControl)

# Create Tabs
$tabPage1 = New-Object System.Windows.Forms.TabPage
$tabPage1.Text = "Create Release"
$tabControl.Controls.Add($tabPage1)

$tabPage2 = New-Object System.Windows.Forms.TabPage
$tabPage2.Text = "Copy Files"
$tabControl.Controls.Add($tabPage2)

$tabPage3 = New-Object System.Windows.Forms.TabPage
$tabPage3.Text = "Execute Sql Scripts"
$tabControl.Controls.Add($tabPage3)



## Create Release Panel
$Panel_CreateRelease = New-Object System.Windows.Forms.Panel
$Panel_CreateRelease.Size = New-Object System.Drawing.Size(900,1200)

$label_Release = New-Object System.Windows.Forms.Label
$label_Release.Text = "Enter Release"
$label_Release.Size = New-Object System.Drawing.Size(100,25)
$label_Release.Location = New-Object System.Drawing.Size(10,10)
$Panel_CreateRelease.Controls.Add($label_Release)

$txt_Release = New-Object System.Windows.Forms.TextBox
$txt_Release.Size = New-Object System.Drawing.Size(200,25)
$txt_Release.Location = New-Object System.Drawing.Size(120,10)
$Panel_CreateRelease.Controls.Add($txt_Release)



$label_Commit = New-Object System.Windows.Forms.Label
$label_Commit.Text = "Enter Commit ID"
$label_Commit.Size = New-Object System.Drawing.Size(100,25)
$label_Commit.Location = New-Object System.Drawing.Size(10,40)
$Panel_CreateRelease.Controls.Add($label_Commit)

$txt_CommitID = New-Object System.Windows.Forms.TextBox
$txt_CommitID.Size = New-Object System.Drawing.Size(200,25)
$txt_CommitID.Location = New-Object System.Drawing.Size(120,40)
$Panel_CreateRelease.Controls.Add($txt_CommitID)

$label_ReleaseFolder = New-Object System.Windows.Forms.Label
$label_ReleaseFolder.Text = "Release Folder"
$label_ReleaseFolder.Size = New-Object System.Drawing.Size(100,25)
$label_ReleaseFolder.Location = New-Object System.Drawing.Size(10,70)
$Panel_CreateRelease.Controls.Add($label_ReleaseFolder)

$txt_ReleaseFolder = New-Object System.Windows.Forms.TextBox
$txt_ReleaseFolder.Size = New-Object System.Drawing.Size(200,25)
$txt_ReleaseFolder.Location = New-Object System.Drawing.Size(120,70)
$Panel_CreateRelease.Controls.Add($txt_ReleaseFolder)

$ReleaseOutputBox = New-Object System.Windows.Forms.RichTextBox 
$ReleaseOutputBox.Location = New-Object System.Drawing.Size(10,200) 
$ReleaseOutputBox.Size = New-Object System.Drawing.Size(1700,580)
$ReleaseOutputBox.AutoSize = $false
$ReleaseOutputBox.MultiLine = $True
$ReleaseOutputBox.WordWrap = $True
$ReleaseOutputBox.ScrollBars = "Both"
$ReleaseOutputBox.Font = New-Object System.Drawing.Font("Courier New", 18)
$Panel_CreateRelease.Controls.Add($ReleaseOutputBox)

$ReleaseButton = New-Object System.Windows.Forms.Button
$ReleaseButton.Size = New-Object System.Drawing.Size(310,30)
$ReleaseButton.Location = New-Object System.Drawing.Size(10,100)
$ReleaseButton.Text = "CREATE RELEASE"
$ReleaseButton.Add_Click({

  $scriptPath = $PSScriptRoot
  Start-Transcript -Path $scriptPath"\transcript.txt" 
  Push-Location $scriptPath
  & $scriptPath"\CreateReleaseArchive.ps1" -firstcommit $txt_Release.Text -secondcommit $txt_CommitID.Text -tag $txt_ReleaseFolder.Text
  Pop-Location
  Stop-Transcript
  $output_release_note = Get-Content -Path $scriptPath"\transcript.txt" -Encoding UTF8
  $ReleaseOutputBox.Text = $output_release_note
    

})
$Panel_CreateRelease.Controls.Add($ReleaseButton)


## Copy FILE PANEL
$Panel_CopyFile = New-Object System.Windows.Forms.Panel
$Panel_CopyFile.Size = New-Object System.Drawing.Size(600,600)

# Initialize variables for the selected source and destination folders
$global:SourceFolder = ""
$global:DestinationFolder = ""

# Create a button to select the source folder
$SourceButton = New-Object System.Windows.Forms.Button
$SourceButton.Location = New-Object System.Drawing.Size(10,20)
$SourceButton.Size = New-Object System.Drawing.Size(180,50)
$SourceButton.Text = "Select Source Folder"
$SourceButton.Add_Click({
    $SourceFolderBrowserDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $SourceFolderBrowserDialog.SelectedPath = "C:\Publicis_1"
    $SourceFolderBrowserDialog.Description = "Select the source folder"
    $SourceFolderBrowserDialog.ShowDialog()
    $global:SourceFolder = $SourceFolderBrowserDialog.SelectedPath
    $SourceLabel.Text = "Selected Source Folder: $SourceFolder"
})
$Panel_CopyFile.Controls.Add($SourceButton)

# Create a button to select the destination folder
$DestinationButton = New-Object System.Windows.Forms.Button
$DestinationButton.Location = New-Object System.Drawing.Size(200,20)
$DestinationButton.Size = New-Object System.Drawing.Size(180,50)
$DestinationButton.Text = "Select Destination Folder"
$DestinationButton.Add_Click({
    $DestinationFolderBrowserDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $DestinationFolderBrowserDialog.SelectedPath = "C:\Publicis_2"
    $DestinationFolderBrowserDialog.Description = "Select the destination folder"
    $DestinationFolderBrowserDialog.ShowDialog()
    $global:DestinationFolder = $DestinationFolderBrowserDialog.SelectedPath
    $DestinationLabel.Text = "Selected Destination Folder: $DestinationFolder"
})
$Panel_CopyFile.Controls.Add($DestinationButton)


# Create a label to display the selected source folder
$SourceLabel = New-Object System.Windows.Forms.Label
$SourceLabel.Location = New-Object System.Drawing.Size(10,100)
$SourceLabel.Size = New-Object System.Drawing.Size(1000,20)
$Panel_CopyFile.Controls.Add($SourceLabel)

# Create a label to display the selected destination folder
$DestinationLabel = New-Object System.Windows.Forms.Label
$DestinationLabel.Location = New-Object System.Drawing.Size(10,120)
$DestinationLabel.Size = New-Object System.Drawing.Size(1000,20)
$Panel_CopyFile.Controls.Add($DestinationLabel)


$Panel_CopyFile.Controls.Add($CopyButton)


# Create a button to start the copy process
$CopyButton = New-Object System.Windows.Forms.Button
$CopyButton.Location = New-Object System.Drawing.Size(430,20)
$CopyButton.Size = New-Object System.Drawing.Size(180,50)
$CopyButton.Text = "Copy"
$CopyButton.Add_Click({
$outputBox.Focus()
   $run = robocopy.exe $global:SourceFolder $global:DestinationFolder "/E" | foreach {
$ErrorActionPreference = "silentlycontinue"

$outputBox.AppendText($_ + "`r`n")
[void] [System.Windows.Forms.Application]::DoEvents()
} 
})


$outputBox = New-Object System.Windows.Forms.RichTextBox 
$outputBox.Location = New-Object System.Drawing.Size(10,200) 
$outputBox.Size = New-Object System.Drawing.Size(1700,580)
$outputBox.MultiLine = $True
#$outputBox.WordWrap = $False
$outputBox.ScrollBars = "Both"
$outputBox.Font = New-Object System.Drawing.Font("Courier New", 18)
$Panel_CopyFile.Controls.Add($outputBox)


$tabPage2.Controls.Add($Panel_CopyFile)
$tabPage1.Controls.Add($Panel_CreateRelease)


$form.Add_Shown({$form.Activate()})
$form.ShowDialog()