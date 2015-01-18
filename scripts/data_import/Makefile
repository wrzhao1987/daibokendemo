#/* vim:noexpandtab
#*/

DATA_PATH=/usr/share/nginx/project/develop/numeric/08
DEST_PATH_SERVER=/home/zcc/nami/config/game
DEST_PATH_CLIENT=/home/zcc/nami-client/config/game
BUILD_PATH=buid

skill:
	lua gen_skill_cfg.lua ${DATA_PATH}/英雄主动技能数值_技术.xml
	lua gen_skill_passive.lua ${DATA_PATH}/英雄被动技能_技术.xml
	lua gen_skill_aura.lua ${DATA_PATH}/英雄光环技能1_技术.xml
	mv skill_.json skill_3.json
	mv Skill_.lua SkillBuff.lua
	lua gen_skill_aura.lua ${DATA_PATH}/英雄光环技能2_技术.xml
	mv skill_.json skill_4.json
	mv Skill_.lua SkillMystery.lua
	mv skill_1.json skill_2.json skill_3.json skill_4.json ${DEST_PATH_SERVER}/

tlmission:
	lua gen_tlmission_cfg.lua ${DATA_PATH}/挑战副本_技术.xml
	lua gen_tlmission_cfg.lua ${DATA_PATH}/悬赏副本_技术.xml

npc:
	lua gen_npc_cfg.lua ${DATA_PATH}/NPC数值统计导入用表_技术.xml

mission1:
	lua gen_mission_cfg.lua ${DATA_PATH}/任务数值_服务器_技术.xml ${DATA_PATH}/任务关卡掉落信息_技术.xml ${DATA_PATH}/NPC数值统计导入用表_技术.xml ${DATA_PATH}/BOSS数值统计导入用表_技术.xml ${DATA_PATH}/任务关卡数值_技术.xml

mission2:
	lua gen_mission_cfg.lua ${DATA_PATH}/任务数值_精英_服务器_技术.xml ${DATA_PATH}/任务关卡掉落信息_精英_技术.xml ${DATA_PATH}/NPC数值统计导入用表_技术.xml ${DATA_PATH}/BOSS数值统计导入用表_技术.xml ${DATA_PATH}/任务关卡数值_精英_技术.xml

gmission:
	lua gen_gmission_cfg.lua ${DATA_PATH}/公会BOSS战.xml

sound:
	lua gen_model_sound.lua ${DATA_PATH}/sounds.xml

card:
	lua gen_card_cfg.lua ${DATA_PATH}/英雄基础数值_技术.xml ${DATA_PATH}/英雄数值_技术.xml ${DATA_PATH}/英雄突破数值_技术.xml

clean:
	ls -Igen* -Ijson_fomatter.lua -IMakefile -Iexcel -Icfg_check.lua -Ibuild | xargs rm 

dailytask:
	lua gen_task_cfg.lua ${DATA_PATH}/daily_task-2.xml

monthcheck:
	lua gen_month_reward.lua ${DATA_PATH}/每日签到.xml


vip:
	lua gen_vip_cfg.lua ${DATA_PATH}/vip_cfg.xml
	sed -i s//\\n/g Vip.lua

temple:
	lua gen_temple_cfg.lua ${DATA_PATH}/神殿.xml

tower:
	lua gen_tower_cfg.lua ${DATA_PATH}/卡琳神塔基础数据.xml ${DATA_PATH}/卡琳神塔关卡怪物_技术.xml

suite:
	lua gen_suite_cfg.lua ${DATA_PATH}/套装_技术.xml

user:
	lua gen_user_cfg.lua ${DATA_PATH}/user_data.xml

equip:
	lua gen_equip_cfg.lua ${DATA_PATH}/装备数值_技术.xml ${DATA_PATH}/equip_desc.xml

droppath:
	lua gen_droppath_cfg.lua ${DATA_PATH}/掉落链接_技术.xml

unlock:
	lua gen_levelunlock_cfg.lua ${DATA_PATH}/等级解锁顺序_技术.xml

rstore:
	lua gen_rstore_cfg.lua ${DATA_PATH}/代币商城_技术.xml


mstar:
	lua gen_mission_bonus_cfg.lua ${DATA_PATH}/任务系统宝箱配置.xml

gbox:
	lua gen_box_cfg.lua ${DATA_PATH}/礼包配置.xml

gacha:
	lua gen_gacha_cfg.lua ${DATA_PATH}/gacha数值.xml

treasurebox:
	lua gen_treasure_box.lua ${DATA_PATH}/宝箱id配置.xml
