#!./php-script.sh
//<?php # - This tag is here only for syntax highlighting, this script can be run without it
var_dump($argv);

echo "\nTest of 4 different ways to call external programs!\n\n";

$command = "sudo snap refresh";
$output = [];
$result_code = 0;

echo "command: $command\n\n";

//--------------
echo "(1) Tries 'shell_exec' on line ", __LINE__, "\n";
echo "Execute command via shell and return the complete output as a string\n";
echo "Returns a string containing the output from the executed command,\nfalse if the pipe cannot be established or\nnull if an error occurs or the command produces no output.\n";
echo "\n\$result = shell_exec(\$command) => \n";
$result = shell_exec($command);

echo "\n", '(1) result on line: ', __LINE__, "\n"; 
if (is_null($result)) { echo '$result is null', "\n"; }
elseif ($result === false) { echo '$result is false', "\n"; }
else { echo "\$result: "; var_dump(preg_split('//u', $result, 0)); echo "len: ", mb_strlen($result), "\n"; }
echo 'gettype($result) => ', gettype($result), "\n\n";

//--------------
echo "(2) Tries 'exec' on line ", __LINE__, "\n";
echo "It should be used when access to the program exit code is required.\n";
echo "Returns the last line from the result of the command.\n"; 
echo "\n\$result = exec(\$command, \$output, \$result_code) => \n";
$result = exec($command, $output, $result_code);

echo "\n", '(2) result on line: ', __LINE__, "\n"; 
if ($result === "") { echo '$result is empty string', ', $result_code: ', $result_code, "\n"; }
else { echo '$result: '; var_dump(preg_split('//u', $result, 0)); echo "\n", '$output: '; var_dump($output ?? []); echo "\n", '$result_code: ', $result_code, "\n";}
echo 'gettype($result) => ', gettype($result), "\n\n";

//--------------
echo "(3) Tries 'passthru' on line ", __LINE__, ")\n";
echo "This function should be used in place of exec() or system()\nwhen the output from the Unix command is binary data\nwhich needs to be passed directly back to the browser.\n";
echo "Returns null on success or false on failure.\n"; 
echo "\n\$result = passthru(\$command, \$result_code) => \n";
$result = passthru($command, $result_code);

echo "\n", '(3) result on line: ', __LINE__, "\n"; 
if (is_null($result)) { echo '$result is null ', ', $result_code: ', $result_code, "\n"; }
else { echo "\n", '$result: ', $result, "\n", ', $result_code: ', $result_code, "\n"; }
echo 'gettype($result) => ', gettype($result), "\n\n";

//--------------
echo "(4) Tries 'system' on line ", __LINE__, ")\n";
echo "It is just like the C version of the function in that it executes the given command and outputs the result.\n";
echo "Returns the last line of the command output on success, and false on failure.\n";
echo "\n\$result = system(\$command, \$result_code) => \n";
$result = system($command, $result_code);

echo "\n", '(4) result on line: ', __LINE__, "\n"; 
if ($result === false) { echo '$result is false', ', $result_code: ', $result_code, "\n"; }
if ($result === "") { echo '$result is empty string', ', $result_code: ', $result_code, "\n"; }
else { echo "\n", '$result: '; var_dump(preg_split('//u', $result, 0)); echo "\n", '$result_code: ', $result_code, "\n"; }
echo 'gettype($result) => ', gettype($result), "\n\n";
