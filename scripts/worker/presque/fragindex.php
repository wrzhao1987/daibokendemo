<?php

require dirname(__FILE__).'/../../../api/libraries/FragmentIndexLib.php';

class FragmentIndex {

    public function perform() {
        if (!isset($this->args['cmd'])) {
            syslog(LOG_ERR, "FragmentIndex worker: cmd not found");
            return;
        }
        $cmd = $this->args['cmd'];
        if (!isset($this->args['role_id'])) {
            syslog(LOG_ERR, "FragmentIndex worker: role_id not found for cmd $cmd");
            return;
        }
        $role_id = $this->args['role_id'];
        syslog(LOG_DEBUG, "fragemnent backjob work on cmd $cmd for role $role_id");
        if (strcmp($cmd, 'levelup') == 0) {
            if (!isset($this->args['old_level']) || !isset($this->args['new_level'])) {
                syslog(LOG_ERR, "FragmentIndex worker: miss args for cmd $cmd");
                return;
            }
            $old_level = $this->args['old_level'];
            $new_level = $this->args['new_level'];
            $idxlib = new FragmentIndexLib();
            $idxlib->levelUp($role_id, $old_level, $new_level);
            
            # another worker job: update index for login_time:level
            #$logintime_level_idxlib = new UserActiveIndexLib();
            #$logintime_level_idxlib->levelUpEvent($role_id, $old_level, $new_level);

        } else if (strcmp($cmd, 'fragchange') == 0) {
            if (!isset($this->args['fragno']) || !isset($this->args['present'])) {
                syslog(LOG_ERR, "FragmentIndex worker: miss args for cmd $cmd");
                return;
            }
            $fragnos = $this->args['fragno'];
            if (!is_array($fragnos)) {
                $fragnos = array($fragnos);
            }
            $present = $this->args['present'];
            $idxlib = new FragmentIndexLib();
            foreach ($fragnos as $fragno) {
                $idxlib->fragmentPresentChange($role_id, $fragno, $present);
            }
        } else {
            syslog(LOG_ERR, "FragmentIndex worker: unknown cmd $cmd");
            return;
        }
    }
}
