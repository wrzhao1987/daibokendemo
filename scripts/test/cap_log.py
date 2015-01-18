import logging

logger = logging.getLogger();
hdlr = logging.StreamHandler();
fmt = logging.Formatter("%(asctime)s [%(levelname)s] %(message)s");
hdlr.setFormatter(fmt);
fhdlr = logging.FileHandler("cap_t.log");
fhdlr.setFormatter(fmt);

logger.addHandler(hdlr);
logger.setLevel(logging.NOTSET);

