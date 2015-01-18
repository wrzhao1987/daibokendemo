# encoding:utf-8 
import cap_log
import logging
import requests
import json
import cfg
import random
import cookielib
import os
import login_pb2

# turn on requests debug
import httplib
httplib.HTTPConnection.debuglevel = 0

logger = logging.getLogger()


def ff(func, *args):
    def wrapper(*args, **kv):
        self = args[0]
        url = "%s%s" % (self.server_addr, self.urlpath.get(func.__name__))
        req_data = kv.get('data')
        res = self.session.post(url, data={'data':json.dumps(req_data)})
        logger.debug("%s" % (res.text))
        try:
            jr = res.json()
            if (jr.get('code') == 200):
                func(*args, **kv)
            else:
                logger.warn("list server failed: %s" % jr)
        except Exception, e:
            logger.warn("fail to %s %s : %s" % (func.__name__, e, res.text))
            pass
    return wrapper

class CapClient(object):

    urlpath = {
        'listserver': '/server/list',
        'register': '/account/register',
        'login': '/account/login',
        'logout': '/account/logout',
        'create_role': '/account/createrole',
        'acctquery': '/account/query',
        'join_arena': '/arena/join',
        'query_rank': '/arena/query',
        'find_opponents': '/arena/search',
        'arena_all': '/arena/general',
        'challenge': '/arena/challenge',
        'challengeresult': '/arena/challengeresult',
        'challenge_history': '/arena/history',
        'gen_name': '/name/generate',
        'robable_items': '/rob/itemlist',
        'find_rob_opponent': '/rob/search',
        'rob_attack': '/rob/attack',
        'rob_commit': '/rob/commit',
        'rob_history': '/rob/history',
        'user_info': '/user/info',
        'user_overview': '/user/overview',
        'mission_prepare': '/mission/prepare',
        'mission_attack': '/mission/attack',
        'mission_commit': '/mission/commit',
        'mission_wipe': '/mission/wipe',
        'history_sections': '/mission/sections',
        'mission_tlrecord': '/mission/tlrecord',
        'buy': '/store/buy',
        'purchase_records': '/store/records',
        'drgbl_list': '/dragonBall/list',
        'drgbl_compose': '/dragonBall/compose',
        'friend_add': '/friend/reqadd',
        'friend_cancel': '/friend/reqcancel',
        'friend_reqop': '/friend/reqop',
        'friend_del': '/friend/del',
        'friend_list': '/friend/list',
        'friend_giveenergy': '/friend/giveenergy',
        'friend_acceptenergy': '/friend/acceptenergy',
        'msgpush_broadcast': '/msgpush/broadcast',
        'msgpush_send': '/msgpush/send',
        'msgpush_query': '/msgpush/query',
        'tech_addexp': '/tech/addexp',
        'tech_list': '/tech/list',
        'mail_list': '/mail/list',
        'mail_accept': '/mail/accept',
        'mail_send': '/mail/send',
        'sysmail_send': '/sys/sendmail',
        'cardraffle_query': '/cardraffle/query',
        'cardraffle_raffle': '/cardraffle/raffle',
        'loginbonus_list': '/loginbonus/list',
        'loginbonus_accept': '/loginbonus/accept',
        'loginbonus_remedy': '/loginbonus/remedy',
        'loginbonus_accuaccept': '/loginbonus/accuaccept',
        'newbie_commit': '/newbie/commit',
        'midas_query': '/midas/query',
        'midas_buy': '/midas/buy',
        'refreshstore_refresh': '/refreshstore/refresh',
        'refreshstore_buy': '/refreshstore/buy',
        'refreshstore_list': '/refreshstore/list',
        'vip_charge': '/vip/charge',
        'guildmission_summon': '/guildmission/summon',
        'guildmission_attack': '/guildmission/attack',
        'guildmission_commit': '/guildmission/commit',
        'guildmission_query': '/guildmission/query',
        'user_setfield': '/user/setfield',
        'campaign_query': '/campaign/query',
        'campaign_accept': '/campaign/accept',
    }

    
    def __init__(self, acct, password):
        self.acct = acct # email
        self.password = password
        self.session = requests.Session()
        self.role_id = None
        self.server_addr = None
        self.servers = {}
        self.status = 0  # 1 online
        self.role = None
        self.opponents = {}
        self.rob_opponents = {}
        self.cookie_filename = "cookie_%s.ck" % (self.acct)
        self.cookies = {}
        self.load_cookie()

    def save_cookie(self, cookies):
        dcookie = requests.utils.dict_from_cookiejar(cookies)
        self.cookies = dcookie
        content = json.dumps(dcookie)
        logger.info("save cookie %s to %s" % (content, self.cookie_filename))
        with open(self.cookie_filename, "w+") as fp:
            fp.write(content)


    def load_cookie(self):
        logger.info("loadcookie...")
        if not os.path.exists(self.cookie_filename):
            return
        with open(self.cookie_filename, "r+") as fp:
            content = fp.read()
            if content:
                dcookie = json.loads(content)
                if dcookie.get('PHPSESSID'):
                    self.status = 1
                self.cookies = dcookie
        logger.info("cookie: %s", self.cookies)


    def post(self, url, *args, **kv):
        res = self.session.post(url, cookies=self.cookies, *args, **kv)
        jr = {}
        logger.debug(res.text)
        try:
            jr = res.json()
        except Exception, e:
            logger.warn("fail to get %s : %s %s[%s]" % (url, e, res.status_code, res.text))
        return jr

    def list_server(self):
        url = "%s%s" % (cfg.entry_addr, self.urlpath.get('listserver'))
        res = self.session.get(url)
        try:
            jr = res.json()
            if (jr.get('code') == 200):
                for server in jr.get('servers', []):
                    self.servers[int(server.get('id'))] = server.get('addr')
                logger.info("got servers %s" % (self.servers))
            else:
                logger.warn("list server failed: %s" % jr)
        except Exception, e:
            logger.warn("fail to list server %s : %s" % (e, res.text))
            pass

    def select_server(self, sid):
        if not self.servers:
            self.list_server()
        self.server_addr = self.servers.get(sid)
        if self.server_addr and not self.server_addr.startswith('http'):
            self.server_addr = "http://%s" % (self.server_addr)
        logger.debug("select server addr: %s" % (self.server_addr))

    def register(self):
        url = "%s%s" % (self.server_addr, self.urlpath.get('register'))
        req_data = {
            'email': self.acct,
            'password': self.password,
        }
        res = self.post(url, data={'data':json.dumps(req_data)})

    def login(self):
        print "login account %s" % (self.acct)
        url = "%s%s" % (self.server_addr, self.urlpath.get('login'))
        #req_data = {
        #    'email': self.acct,
        #    'password': self.password,
        #}
        #res = self.session.post(url, data={'data':json.dumps(req_data)})
        data = login_pb2.msg_login()
        data.username = self.acct
        data.password = self.password 
        res = self.session.post(url, data={'data':data.SerializeToString()})
        logger.debug("%s" % (res.text))
        jr = res.json()
        logger.info("%s" % res.cookies)
        self.save_cookie(res.cookies)
        if jr.get('code', 0) == 200:
            self.status = 1
            users = jr.get('users', [])
            if users:
                self.role = users[0]
                logger.debug('logged in with role %s', self.role.get('id', -1))
            else:
                logger.debug('logged in without role')

    def create_role(self, name):
        url = "%s%s" % (self.server_addr, self.urlpath.get('create_role'))
        req_data = {
            'name': name,
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})

    def join_arena(self):
        url = "%s%s" % (self.server_addr, self.urlpath.get('join_arena'))
        req_data = {
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            self.rank = jr.get('rank', -1)
        else:
            logger.warn("failed %s" % (url))

    def query_rank(self):
        url = "%s%s" % (self.server_addr, self.urlpath.get('query_rank'))
        req_data = {
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            pass
        else:
            logger.warn("failed %s" % (url))

    def find_opponents(self):
        url = "%s%s" % (self.server_addr, self.urlpath.get('find_opponents'))
        req_data = {
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            self.opponents = jr.get('users')
        else:
            logger.warn("failed %s" % (url))

    def arena_all(self):
        url = "%s%s" % (self.server_addr, self.urlpath.get('arena_all'))
        req_data = {
            'opponents': 1,
            'rank': 1,
            'best_rank': 1,
            'new_award': 1,
            'top_ranks': 1,
            'deck': 1,
            'energy': 1,
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            self.opponents = jr.get('opponents')
        else:
            logger.warn("failed %s" % (url))

    def challenge(self, uid=None):
        url = "%s%s" % (self.server_addr, self.urlpath.get('challenge'))
        if not uid:
            if not self.opponents:
                logger.warn("no opponents to challenge")
                return
            user = random.choice(self.opponents)
            uid = user['uid']
        logger.info("challenge user %s" % (uid))
        req_data = {
            'opponent': uid,
            'get_deck': 1
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            return jr.get('challenge_id')
        else:
            logger.warn("failed %s" % (url))
            return None

    def challengeresult(self, cid, r):
        url = "%s%s" % (self.server_addr, self.urlpath.get('challengeresult'))
        logger.debug("challenge %s commited with %s" % (cid, r))
        req_data = {
            'challenge_id': cid,
            'result': r,
            'info': "nothing to said",
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            self.rank = jr.get('rank')
        else:
            logger.warn("failed %s" % (url))

    def challenge_history(self):
        url = "%s%s" % (self.server_addr, self.urlpath.get('challenge_history'))
        req_data = {
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            pass
        else:
            logger.warn("failed %s" % (url))

    def gen_name(self):
        url = "%s%s" % (self.server_addr, self.urlpath.get('gen_name'))
        req_data = {
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            pass
        else:
            logger.warn("failed %s" % (url))

    def robable_items(self):
        url = "%s%s" % (self.server_addr, self.urlpath.get('robable_items'))
        req_data = {
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            pass
        else:
            logger.warn("failed %s" % (url))

    def find_rob_opponent(self, item=None):
        url = "%s%s" % (self.server_addr, self.urlpath.get('find_rob_opponent'))
        req_data = {
            'item': item,
            'protect_status': 1
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            pass
        else:
            logger.warn("failed %s" % (url))

    def rob_attack(self, user=None, item={}):
        url = "%s%s" % (self.server_addr, self.urlpath.get('rob_attack'))
        if not user:
            if not self.rob_opponents:
                logger.warn("no opponents to rob")
                return
            user = random.choice(self.rob_opponents.keys())
        if self.opponents.get(user):
            del(self.opponents[user])

        req_data = {
            'opponent': user,
            'item': item,
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            return jr.get('rob_id')
        else:
            logger.warn("failed %s" % (url))
            return None

    def rob_commit(self, rob_id, result):
        url = "%s%s" % (self.server_addr, self.urlpath.get('rob_commit'))
        req_data = {
            'rob_id': rob_id,
            'result': result,
            'info': 'robbery',
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            pass
        else:
            logger.warn("failed %s" % (url))

    def rob_history(self):
        url = "%s%s" % (self.server_addr, self.urlpath.get('rob_history'))
        req_data = {
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            pass
        else:
            logger.warn("failed %s" % (url))

    def user_info(self, uids=None, attrs=None):
        url = "%s%s" % (self.server_addr, self.urlpath.get('user_info'))
        req_data = {
        }
        if (uids):
            req_data['users'] = uids
        if (attrs):
            req_data['attrs'] = attrs
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            pass
        else:
            logger.warn("failed %s" % (url))

    def user_overview(self, uids=None):
        url = "%s%s" % (self.server_addr, self.urlpath.get('user_overview'))
        req_data = {
            'users': uids
        }
        if (uids):
            req_data['users'] = uids
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            pass
        else:
            logger.warn("failed %s" % (url))

    def mission_prepare(self, mtype=0):
        url = "%s%s" % (self.server_addr, self.urlpath.get('mission_prepare'))
        req_data = {
            'type': mtype
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            pass
        else:
            logger.warn("failed %s" % (url))

    def mission_attack(self, section, mtype=0, mercenary=None):
        url = "%s%s" % (self.server_addr, self.urlpath.get('mission_attack'))
        req_data = {
            'section_id': section,
            'mercenary': mercenary,
            'type': mtype
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            return jr.get('battle_id')
        else:
            logger.warn("failed %s" % (url))

    def mission_commit(self, battle_id, result, mtype=0, deaths=0):
        url = "%s%s" % (self.server_addr, self.urlpath.get('mission_commit'))
        req_data = {
            'battle_id': battle_id,
            'result': result,
            'deaths': deaths,
            'type': mtype
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            pass
        else:
            logger.warn("failed %s" % (url))

    def mission_wipe(self, section, mtype=0, count=1, free=0):
        url = "%s%s" % (self.server_addr, self.urlpath.get('mission_wipe'))
        req_data = {
            'section_id': section,
            'count': count,
            'free': free,
            'type': mtype
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            pass
        else:
            logger.warn("failed %s" % (url))

    def history_sections(self, mtype=0):
        url = "%s%s" % (self.server_addr, self.urlpath.get('history_sections'))
        req_data = {
            'type': mtype
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            pass
        else:
            logger.warn("failed %s" % (url))

    def buy(self, commodity_id=1, count=1, store_id=1, ):
        url = "%s%s" % (self.server_addr, self.urlpath.get('buy'))
        req_data = {
            'store_id': store_id,
            'commodity_id': commodity_id,
            'count': count
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            pass
        else:
            logger.warn("failed %s" % (url))

    def purchase_records(self):
        url = "%s%s" % (self.server_addr, self.urlpath.get('purchase_records'))
        req_data = {
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            pass
        else:
            logger.warn("failed %s" % (url))

    def drgbl_compose(self, ball_id):
        url = "%s%s" % (self.server_addr, self.urlpath.get('drgbl_compose'))
        req_data = {
            'db_id': ball_id,
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            pass
        else:
            logger.warn("failed %s" % (url))

    def drgbl_list(self):
        url = "%s%s" % (self.server_addr, self.urlpath.get('drgbl_list'))
        req_data = {
            'fragments': 1,
            'balls': 1,
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            pass
        else:
            logger.warn("failed %s" % (url))

    def friend_add(self, target):
        url = "%s%s" % (self.server_addr, self.urlpath.get('friend_add'))
        req_data = {
            'uid': target,
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            pass
        else:
            logger.warn("failed %s" % (url))

    def friend_cancel(self, target):
        url = "%s%s" % (self.server_addr, self.urlpath.get('friend_cancel'))
        req_data = {
            'uid': target,
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            pass
        else:
            logger.warn("failed %s" % (url))

    def friend_reqop(self, target, approve):
        url = "%s%s" % (self.server_addr, self.urlpath.get('friend_reqop'))
        req_data = {
            'uid': target,
            'approve': approve
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            pass
        else:
            logger.warn("failed %s" % (url))

    def friend_del(self, target):
        url = "%s%s" % (self.server_addr, self.urlpath.get('friend_del'))
        req_data = {
            'uid': target,
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            pass
        else:
            logger.warn("failed %s" % (url))

    def friend_giveenergy(self, target):
        url = "%s%s" % (self.server_addr, self.urlpath.get('friend_giveenergy'))
        req_data = {
            'uid': target
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            pass
        else:
            logger.warn("failed %s" % (url))

    def friend_acceptenergy(self, target):
        url = "%s%s" % (self.server_addr, self.urlpath.get('friend_acceptenergy'))
        req_data = {
            'uid': target
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            pass
        else:
            logger.warn("failed %s" % (url))

    def msgpush_broadcast(self, msg):
        url = "%s%s" % (self.server_addr, self.urlpath.get('msgpush_broadcast'))
        req_data = {
            'msg': msg
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            pass
        else:
            logger.warn("failed %s" % (url))

    def friend_list(self):
        url = "%s%s" % (self.server_addr, self.urlpath.get('friend_list'))
        req_data = {
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            pass
        else:
            logger.warn("failed %s" % (url))

    def tech_list(self):
        url = "%s%s" % (self.server_addr, self.urlpath.get('tech_list'))
        req_data = {
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            pass
        else:
            logger.warn("failed %s" % (url))

    def tech_addexp(self, tech_id):
        url = "%s%s" % (self.server_addr, self.urlpath.get('tech_addexp'))
        req_data = {
            'tech_id': tech_id,
            'cost_cards':[],
            'cost_equips':[],
            'cost_card_sprits':{}
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            pass
        else:
            logger.warn("failed %s" % (url))

    def mail_list(self):
        url = "%s%s" % (self.server_addr, self.urlpath.get('mail_list'))
        req_data = {
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            pass
        else:
            logger.warn("failed %s" % (url))

    def mail_accept(self, mail_id):
        url = "%s%s" % (self.server_addr, self.urlpath.get('mail_accept'))
        req_data = {
            'mail_id': mail_id
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            pass
        else:
            logger.warn("failed %s" % (url))

    def mail_send(self, text, attachment, targets):
        url = "%s%s" % (self.server_addr, self.urlpath.get('mail_send'))
        req_data = {
            'mail_text': text,
            'attachment': attachment,
            'targets': targets
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            pass
        else:
            logger.warn("failed %s" % (url))

    def sysmail_send(self, text, attachment, targets, from_name):
        url = "%s%s" % (self.server_addr, self.urlpath.get('sysmail_send'))
        req_data = {
            'mail_text': text,
            'attachment': attachment,
            'targets': targets,
            'from_name': from_name
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            pass
        else:
            logger.warn("failed %s" % (url))

    def cardraffle_query(self):
        url = "%s%s" % (self.server_addr, self.urlpath.get('cardraffle_query'))
        req_data = {
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            pass
        else:
            logger.warn("failed %s" % (url))

    def cardraffle_raffle(self, rtype, raffle_type):
        url = "%s%s" % (self.server_addr, self.urlpath.get('cardraffle_raffle'))
        req_data = {
            'type': rtype,
            'raffle_type': raffle_type
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            pass
        else:
            logger.warn("failed %s" % (url))

    def loginbonus_list(self):
        url = "%s%s" % (self.server_addr, self.urlpath.get('loginbonus_list'))
        req_data = {
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            pass
        else:
            logger.warn("failed %s" % (url))

    def loginbonus_accept(self):
        url = "%s%s" % (self.server_addr, self.urlpath.get('loginbonus_accept'))
        req_data = {
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            pass
        else:
            logger.warn("failed %s" % (url))

    def loginbonus_remedy(self, date):
        url = "%s%s" % (self.server_addr, self.urlpath.get('loginbonus_remedy'))
        req_data = {
            'date': date
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            pass
        else:
            logger.warn("failed %s" % (url))

    def loginbonus_accuaccept(self, accu):
        url = "%s%s" % (self.server_addr, self.urlpath.get('loginbonus_accuaccept'))
        req_data = {
            'accu_value': accu
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            pass
        else:
            logger.warn("failed %s" % (url))

    def newbie_commit(self, step):
        url = "%s%s" % (self.server_addr, self.urlpath.get('newbie_commit'))
        req_data = {
            'step': step
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            pass
        else:
            logger.warn("failed %s" % (url))

    def midas_query(self):
        url = "%s%s" % (self.server_addr, self.urlpath.get('midas_query'))
        req_data = {
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            pass
        else:
            logger.warn("failed %s" % (url))

    def midas_buy(self):
        url = "%s%s" % (self.server_addr, self.urlpath.get('midas_buy'))
        req_data = {
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            pass
        else:
            logger.warn("failed %s" % (url))

    def refreshstore_refresh(self):
        url = "%s%s" % (self.server_addr, self.urlpath.get('refreshstore_refresh'))
        req_data = {
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            pass
        else:
            logger.warn("failed %s" % (url))

    def refreshstore_buy(self):
        url = "%s%s" % (self.server_addr, self.urlpath.get('refreshstore_buy'))
        req_data = {
            'commodity_id': 1
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            pass
        else:
            logger.warn("failed %s" % (url))

    def refreshstore_list(self):
        url = "%s%s" % (self.server_addr, self.urlpath.get('refreshstore_list'))
        req_data = {
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            pass
        else:
            logger.warn("failed %s" % (url))

    def vip_charge(self, pkg_id):
        url = "%s%s" % (self.server_addr, self.urlpath.get('vip_charge'))
        req_data = {
            'package_id': pkg_id
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            pass
        else:
            logger.warn("failed %s" % (url))

    def mission_tlrecord(self):
        url = "%s%s" % (self.server_addr, self.urlpath.get('mission_tlrecord'))
        req_data = {
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            pass
        else:
            logger.warn("failed %s" % (url))

    def guildmission_summon(self, boss_id):
        url = "%s%s" % (self.server_addr, self.urlpath.get('guildmission_summon'))
        req_data = {
            'boss_id': boss_id,
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            return jr.get('boss')
        else:
            logger.warn("failed %s" % (url))

    def guildmission_query(self):
        url = "%s%s" % (self.server_addr, self.urlpath.get('guildmission_query'))
        req_data = {
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            return jr.get('bosses')
        else:
            logger.warn("failed %s" % (url))

    def guildmission_attack(self, boss_uid):
        url = "%s%s" % (self.server_addr, self.urlpath.get('guildmission_attack'))
        req_data = {
            'boss_uid': boss_uid,
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            return jr.get('battle_id')
        else:
            logger.warn("failed %s" % (url))

    def guildmission_commit(self, battle_id, damage=30):
        url = "%s%s" % (self.server_addr, self.urlpath.get('guildmission_commit'))
        req_data = {
            'battle_id': battle_id,
            'damage': damage,
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            return jr.get('boss')
        else:
            logger.warn("failed %s" % (url))

    def user_setfield(self, key, value):
        url = "%s%s" % (self.server_addr, self.urlpath.get('user_setfield'))
        req_data = {
            'field': key,
            'value': 1,
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            pass
        else:
            logger.warn("failed %s" % (url))

    def msgpush_send(self, to, text, type):
        url = "%s%s" % (self.server_addr, self.urlpath.get('msgpush_send'))
        req_data = {
            'text': text,
            'to': to,
            'type': type,
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            pass
        else:
            logger.warn("failed %s" % (url))

    def msgpush_query(self, since):
        url = "%s%s" % (self.server_addr, self.urlpath.get('msgpush_query'))
        req_data = {
            'since':since
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            pass
        else:
            logger.warn("failed %s" % (url))

    def campaign_query(self):
        url = "%s%s" % (self.server_addr, self.urlpath.get('campaign_query'))
        req_data = {
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            pass
        else:
            logger.warn("failed %s" % (url))

    def campaign_accept(self, campaign_id, award_id):
        url = "%s%s" % (self.server_addr, self.urlpath.get('campaign_accept'))
        req_data = {
            'campaign_id': campaign_id,
            'award_id': award_id,
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            pass
        else:
            logger.warn("failed %s" % (url))

    def func(self):
        url = "%s%s" % (self.server_addr, self.urlpath.get(''))
        req_data = {
        }
        jr = self.post(url, data={'data':json.dumps(req_data)})
        if (jr.get('code') == 200):
            pass
        else:
            logger.warn("failed %s" % (url))


def ensure_online(func, *args):
    def wrapper(*args, **kv):
        acct = args
        c = CapClient('chet@capricorn.com', '123456')
        c.select_server(cfg.server_id)
        c.register()
        if 1 or not c.status:
            c.login()
            if not c.role:
                c.create_role()
        if c.status==1:
            func(c, *args, **kv)
    return wrapper

def inject_user():
    i = 0
    while i<10:
        i += 1
        name = 'chet%d' % (i)
        acct = '%s@capricorn.com' % (name)
        c = CapClient(acct, '123456')
        c.select_server(cfg.server_id)
        c.register()
        c.login()
        c.create_role(name)
        logger.info("injected user %s" % (name))


def test_arena(c):
    #c.join_arena()
    #c.query_rank()
    #c.find_opponents()
    c.arena_all()
    cid = c.challenge()
    logger.info("challenge battle %s" % cid)
    if cid:
        c.challengeresult(cid, random.randint(1,1))
    #c.challenge_history()

def prepare_user(tid, name=False, acct=False):
    if not name:
        name = 'chet%d' % (tid)
    if not acct:
        acct = '%s@capricorn.com' % (name)
    c = CapClient(acct, '123456')
    c.select_server(cfg.server_id)
    c.register()
    if not c.status:
        c.login()
        if not c.role:
            logger.info("creating user %s" % (name))
            c.create_role(name)
    return c

def test_rob(c):
    #c.robable_items()
    c.find_rob_opponent({'item_id': 7, 'sub_id': 29,})
    rid = c.rob_attack(385, {'item_id':7, 'sub_id':29})
    logger.info("rob battle %s" % rid)
    if rid:
        pass
        c.rob_commit(rid, 1)
    c.rob_history()

def test_mission(c):
    #c.user_info((1,167,3))
    #c.user_overview((1,219,3))
    c.mission_prepare(2)
    btl_id = c.mission_attack(1, 2)
    if btl_id:
        pass
        c.mission_commit(btl_id, 1, 0, 2)
    #c.mission_wipe(1, 3, free=random.randint(0,0))
    #c.history_sections(2)
    c.mission_tlrecord()

def test_store(c):
    c.buy(1, 2, 2)
    c.buy(2, 1, 2)
    c.buy(2, 2, 3)
    c.buy(2, 1, 4)
    #c.purchase_records()

def test_drgbl(c):
    c.drgbl_list()
    c.drgbl_compose(1)

def test_friend(c1, c2):
    uid1 = c1.role.get('id', None)
    uid2 = c2.role.get('id', None)
    if not uid1 or not uid2:
        logger.warn("user not ready")
        return
    c1.friend_add(uid2)
    if random.randint(0,1):
        c2.friend_reqop(uid1, 1)
    else:
        c2.friend_reqop(uid1, 0)
    c1.friend_list()
    c2.friend_list()
    #c1.friend_del(uid2)
    c1.friend_giveenergy(uid2)
    c2.friend_acceptenergy(uid1)

def test_msg(c):
    #c.msgpush_broadcast('hello world')
    c.msgpush_send(516, 'hello world', 3)
    import time
    c.msgpush_query(None)

def test_tech(c):
    c.tech_list()
    c.tech_addexp(1)

def test_mail(c):
    c.mail_list()
    c.sysmail_send('greeting\nhello', [{'item_id':1, 'sub_id':1, 'count':10}], [392], 'adm');
    #c.mail_send('hello', [{'item_id':1, 'sub_id':1, 'count':10}], [0]);
    c.mail_accept(4070)

def test_cardraffle(c):
    c.cardraffle_query()
    c.cardraffle_raffle(2, 2)

def test_loginbonus(c):
    c.loginbonus_list()
    c.loginbonus_accept()
    c.loginbonus_remedy('2014-05-01')
    c.loginbonus_accuaccept(7)

def test_newguide(c):
    c.user_info()
    step = 1
    while True:
        c.newbie_commit(step)
        step += 1
        if step > 18:
            break

def test_midas(c):
    c.midas_query()
    c.midas_buy()

def test_refresh_store(c):
    c.refreshstore_refresh()
    c.refreshstore_buy()
    c.refreshstore_list()

def test_charge(c):
    c.vip_charge(1)

def test_guildboss(c):
    bosses = c.guildmission_query()
    boss_id = "2"
    boss = bosses.get(boss_id, None)
    if boss is None or len(boss)==0 or int(boss['hp']) <= 0:
        logger.info("summon new boss")
        boss = c.guildmission_summon(boss_id)
        if len(boss)==0:
            logger.warn('fail to summon')
            return
    battle_id = c.guildmission_attack(boss['boss_uid'])
    logger.info("battle_id:%s" % (battle_id))
    if battle_id:
        boss = c.guildmission_commit(battle_id, 50)
        logger.info("hp:%s",boss['hp'])

def test_campaign(c):
    c.campaign_query()
    c.campaign_accept(1, 3)

if __name__ == "__main__":
    c = prepare_user(0, '5', 'K4')
    #c.user_setfield('ng7', 10)
    #c = prepare_user(26)
    #test_mission(c)
    #test_rob(c)
    #test_arena(c)
    #test_store(c)
    #test_drgbl(c)
    #inject_user()
    #c1 = prepare_user(0, 'ccc', 'c@c.com')
    #test_friend(c, c1)
    #test_msg(c)
    #test_tech(c)
    #test_mail(c)
    test_cardraffle(c)
    #test_loginbonus(c)
    #test_newguide(c)
    #test_midas(c)
    #test_charge(c)
    #test_refresh_store(c)
    #test_guildboss(c)
    #test_campaign(c)

