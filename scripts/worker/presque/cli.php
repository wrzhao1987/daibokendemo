<?php
class Cli
{
    public function perform()
    {
        $task      = $this->args['task'];
        $action    = $this->args['action'];
        $arguments = isset($this->args['arguments']) ? strval($this->args['arguments']) : '';
        $script_name = __DIR__ . '../../../public/app/cli.php';

        if ($task && $action)
        {
            $command = "{$script_name} {$task} {$action} {$arguments}";
            try
            {
                shell_exec($command);
            }
            catch (Exception $e)
            {
                syslog(LOG_CRIT, $e->getMessage());
            }
        }
    }
}