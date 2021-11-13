#!/bin/bash

GREP="grep --exclude-dir=.git --exclude-dir=common --exclude=info.sh"

[ -d common ] && rm -rf common

function dump_common() {
	find . ! -path "./common/*" -type f -iname info.txt -exec cat {} \; \
		| $GREP $1 \
			| sort -u \
				| cut -f1 -d' ' \
					| while read sha; do mkdir -p "common/$1/$sha"; cp "$($GREP -r $sha | head -n1 | cut -f1 -d/)/$1" "common/$1/$sha"; done
}

function dump_info() {
	echo -e "\n$1" >> common/info.txt
	find . ! -path "./common/*" -type f -iname info.txt -exec cat {} \; \
		| $GREP $1 \
			| sort -u \
				| cut -f1 -d' ' \
					| while read sha; do echo -e "\n[$sha]"; $GREP -r $sha | sed "s/_/ /g" | sort -k2 | sed "s/ /_/g"; done \
						| cut -f1 -d/ >> common/info.txt
}

dump_common j20s_novatek_ts_fw01.bin.ihex
dump_common j20s_novatek_ts_mp01.bin.ihex
dump_common j20s_novatek_ts_fw02.bin.ihex
dump_common j20s_novatek_ts_mp02.bin.ihex

dump_info j20s_novatek_ts_fw01.bin.ihex
dump_info j20s_novatek_ts_mp01.bin.ihex
dump_info j20s_novatek_ts_fw02.bin.ihex
dump_info j20s_novatek_ts_mp02.bin.ihex
