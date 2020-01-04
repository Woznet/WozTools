function Restart-Process{
	<#
			.SYNOPSIS
			Function to restart process(es)
			.DESCRIPTION
			Takes input via pipeline from Get-Process and restarts the process(es). If there is more than one instance of the same application:
			Then the function prompts to select the instance of the application to restart by index. An index of -1 stops all instances of the application and
			restarts the first.
			.PARAMETER process
			Process(es) to restart piped in via Get-Process
			.EXAMPLE
			#start 2 instances of notepad and restart the second
			notepad
			notepad
			Get-Process notepad | Restart-Process
			#enter index 2 when prompted
			.EXAMPLE
			#start 3 instances of notepad restart the first and stop the others
			notepad
			notepad
			notepad
			Get-Process notepad | Restart-Process
			#enter index -1 when prompted
			.Example
			#start notepad and calc and restart
			Get-Process notepad,calc | Restart-Process
	#>
	[CmdletBinding()]
	param([Parameter(ValueFromPipeline = $true)] $process)
	Begin{
		$selectedIndex=$multiInstanceName=$null
	}
	Process{
		if ($multiInstanceName -eq $_.Name){continue}
		$procToRestart=$_
		#handle if there are multiple instances of the same application
		if ((Get-Process $_.Name).Count -gt 1){
			$multiInstanceName=$_.Name
			$counter = 0
			$processInstances=Get-Process $_.Name
			Write-Host "There are multiple instances of $($_.Name)."
			$prompt+=@("Provide the index of the instance to stop (-1 for all instances first instance will be restarted): ")
			foreach($instance in $processInstances){
				$counter++
				$prompt+="{0} . {1}" -f $counter,$instance.MainWindowTitle
			}
			Add-Type -AssemblyName 'Microsoft.VisualBasic'
			$selectedIndex = [Microsoft.VisualBasic.Interaction]::InputBox(($prompt -join "`n"), "Select Process instance", "1")
			$indices=(0..($processInstances.Length-1))
			switch ($selectedIndex){
				#clicked cancel
				$null 							{exit}
				#stop all instances but the first
				-1								{
					$indices=$indices -ne 0
					foreach ($index in $indices){
						$processInstances[$index].Kill()
						$processInstances[$index].WaitForExit()
					}
					$selectedIndex=1
					break
				}
				#mismatching arguments
				{$indices -notcontains ($_-1)} 	{
					Write-Warning "Index is out of bounds.Exit"
					exit
				}
			}
			$procToRestart=$processInstances[$selectedIndex-1]
		}
		Write-Host "Restarting: $($procToRestart.MainWindowTitle)"
		$cmdPath,$cmdArguments = (Get-WMIObject Win32_Process -Filter "Handle=$($_.Id)").CommandLine.Split()
		$procToRestart.Kill()
		$procToRestart.WaitForExit()
		if ($cmdArguments) { Start-Process -FilePath $cmdPath -ArgumentList $cmdArguments }
		else { Start-Process -FilePath $cmdPath }
	}
}