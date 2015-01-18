<?php
/**
 * Created by PhpStorm.
 * User: Martin
 * Date: 14-3-14
 * Time: 下午12:20
 */
define('HERO_MAX_LEVEL', 100); // 英雄最高等级
define('HERO_MAX_PHASE', 3); // 英雄最多突破阶段数
define('HERO_MAX_DRAGON_BALL_COUNT', 4); // 英雄装备最多龙珠数
define('HERO_MAX_EQUIP_COUNT', 4); // 英雄可装备的装备数量上限
define('HERO_MAX_SKILL_COUNT', 4); // 英雄拥有的最多技能数

define('HERO_PROPERTY_ATK', 1); // 攻击力
define('HERO_PROPERTY_DEF', 2); // 防御力
define('HERO_PROPERTY_HP',  3); // 生命值

define('NORMAL_TRAIL', 1); // 普通修炼
define('NORMAL_TRAIL_10', 2); // 普通修炼
define('PREMIUM_TRAIL', 3); // 高级修炼
define('PREMIUM_TRAIL_10', 4); // 高级修炼10次

define('NORMAL_TRAIL_MIN_DELTA', 1);    // 普通修炼时，最低属性增量
define('NORMAL_TRAIL_MAX_DELTA', 3);    // 普通修炼时，最高属性增量
define('PREMIUM_TRAIL_MIN_DELTA', 1);   // 高级修炼时，最低属性增量
define('PREMIUM_TRAIL_MAX_DELTA', 7);   // 高级修炼时，最高属性增量

define('USER_DECK_LEADER_POSITION', 1);
define('USER_DECK_MAX_POSITION', 6);
define('USER_DECK_FRIEND_POSITION', 7);

define('EQUIP_TYPE_WEAPON', 1);
define('EQUIP_TYPE_ARMOR',  2);
define('EQUIP_TYPE_RING',   3);

define('DECK_TYPE_PVE', 1);
define('DECK_TYPE_PVP', 2);

define('REDIS_DEFAULT_TTL', 86400 * 2); // Redis默认TTL
define('REDIS_DEFAULT_EXPIRE', '05:00'); // 默认重置时间

define('ITEM_TYPE_DIAMOND',              1); // 钻石
define('ITEM_TYPE_SONY',                 2); // 索尼币
define('ITEM_TYPE_HERO',                 3); // 英雄
define('ITEM_TYPE_DRAGON_BALL',          4); // 龙珠
define('ITEM_TYPE_EQUIP',                5); // 装备
define('ITEM_TYPE_HERO_FRAGMENT',        6); // 英雄碎片
define('ITEM_TYPE_DRAGON_BALL_FRAGMENT', 7); // 龙珠碎片
define('ITEM_TYPE_TRAIL_MEDICINE',       8); // 修炼时消耗的药水
define('ITEM_TYPE_EXP_MEDICINE',         9); // 经验药水
define('ITEM_TYPE_AVOID_FIGHT_TOKEN',   10); // 免战牌
define('ITEM_TYPE_TREASURE_BOX_KEY',    11); // 宝箱钥匙
define('ITEM_TYPE_TREASURE_BOX',        12); // 宝箱
define('ITEM_TYPE_GIFT_BOX',            15); // 礼包
define('ITEM_TYPE_ENERGY_MEDICINE',     16); // PVE能量药水
define('ITEM_TYPE_GENKI_MEDICINE',      17); // PVP元气药水
define('ITEM_TYPE_USER_EXP',            18); // 战队经验
define('ITEM_TYPE_GACHA_TICKET',        19); // Gacha券
define('ITEM_TYPE_EQUIP_FRAGMENT',      20); // 装备碎片
define('ITEM_TYPE_STAMINA',             21); // 用户体力
define('ITEM_TYPE_HONOR',               22); // 荣誉
define('ITEM_TYPE_SNAKE',               23); // 蛇王币

define('ENERGY_MEDICINE_AMOUNT', 120);
define('KARIN_MAX_FLOOR', 50); // 卡林神塔的最高层数
define('KARIN_RESET_DIAMOND', 40); // 重置卡林神塔需要的钻石数
