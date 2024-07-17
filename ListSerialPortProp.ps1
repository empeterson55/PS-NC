# Returns information about the serial ports installed on a computer

Try {
	$SerialPort = get-wmiobject -class "Win32_SerialPort" 
	foreach ($PortItem in $SerialPort) { 
		switch ($PortItem.Availability ) {
			1{$Availability = "Other"}
            2{$Availability = "Unknown"}
            3{$Availability = "Running or Full Power"}
            4{$Availability = "Warning"}
			5{$Availability = "In Test"}
            6{$Availability = "Not Applicable"}
            7{$Availability = "Power Off"}
            8{$Availability = "Off Line"}
            9{$Availability = "Off Duty"}
            10{$Availability = "Degraded"}
            11{$Availability = "Not Installed"}
			12{$Availability = "Install Error"}
            13{$Availability = "Power Save - Unknown"}
            14{$Availability = "Power Save - Low Power Mode"}
            15{$Availability = "Power Save - Standby"}
            16{$Availability = "Power Cycle"}
            17{$Availability = "Power Save - Warning"}
			}
		switch ($PortItem.PowerManagementCapabilities ) {
			0{$PowerManagementCapabilities = "Unknown"}
			1{$PowerManagementCapabilities = "Not Supported"}
            2{$PowerManagementCapabilities = "Disabled"}
            3{$PowerManagementCapabilities = "Enabled"}
            4{$PowerManagementCapabilities = "Power Saving Modes Entered Automatically"}
			5{$PowerManagementCapabilities = "Power State Settable"}
            6{$PowerManagementCapabilities = "Power Cycling Supported"}
            7{$PowerManagementCapabilities = "Timed Power-On Supported"}
			}
		switch ($PortItem.StatusInfo ) {
			1{$StatusInfo = "Other"}
            2{$StatusInfo = "Unknown"}
            3{$StatusInfo = "Enabled"}
            4{$StatusInfo = "Disabled"}
			5{$StatusInfo = "Disabled"}
			}
		write-host "Availability is                  " $Availability 
		write-host "Binary is                        " $PortItem.Binary 
        write-host "Caption is                       " $PortItem.Caption 
	    write-host "Device id is                     " $PortItem.DeviceID 
	    write-host "Maximum baud rate is             " $PortItem.MaxBaudRate "Bits per second"
	    write-host "Maximum input buffer size is     " $PortItem.MaximumInputBufferSize "Bytes"
		write-host "Maximum output buffer size is    " $PortItem.MaximumOutputBufferSize "Bytes"
	    write-host "PNP Device id is                 " $PortItem.PNPDeviceID 
	    write-host "Power management capabilities is " $PowerManagementCapabilities 
        write-host "Power management supported is    " $PortItem.PowerManagementSupported 
	    write-host "Provider type  is                " $PortItem.ProviderType 
		write-host "Settable baud rate is            " $PortItem.SettableBaudRate 
		write-host "Settable data bits is            " $PortItem.SettableDataBits 
		write-host "Settable flow control is         " $PortItem.SettableFlowControl 
	 	write-host "Settable RLSD is                 " $PortItem.SettableRLSD 
		write-host "Settable stop bits is            " $PortItem.SettableStopBits 
		write-host "Status is                        " $PortItem.Status 
	    write-host "Status information is            " $StatusInfo
		write-host "Supports DTRDSR is               " $PortItem.SupportsDTRDSR 
		write-host "Supports elapsed timeouts is     " $PortItem.SupportsElapsedTimeouts 
		write-host "Supports int timeouts is         " $PortItem.SupportsIntTimeouts 
		write-host "Supports parity check is         " $PortItem.SupportsParityCheck 
		write-host "Supports RLSD is                 " $PortItem.SupportsRLSD 
		write-host "Supports RTSCTS is               " $PortItem.SupportsRTSCTS 
		write-host "Supports special characters is   " $PortItem.SupportsSpecialCharacters 
        write-host "System creation class name is    " $PortItem.SystemCreationClassName 
        write-host "System name is                   " $PortItem.SystemName 
        write-host 
		} 
	write-host "Successfully passed"
	exit 0
	}
Catch {
	write-host "Failure"
	exit 1001
	  }
