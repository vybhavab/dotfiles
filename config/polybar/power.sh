echo - | acpi -b | grep "Battery 1" | grep Discharging  | cut -f 5 -d " ";
echo - | acpi -b | grep "Battery 1" | grep Charging | cut -f 5 -d " ";
