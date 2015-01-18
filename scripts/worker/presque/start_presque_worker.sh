#!/bin/bash
path=$(dirname $0)
QUEUE=arena,fragindex,user,mission,battle,item,deck,equip,dball,card,kpi php $path/resque.php

