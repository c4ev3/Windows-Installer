JAR_PLUGIN_BASENAME	:= de.h-ab.ev3plugin
JAR_PLUGIN_VERSION	?= 1.7.2.201908011455
GCC_INSTALLER		?= arm-2009q1-203-arm-none-linux-gnueabi.exe

JAR_PLUGIN		:= ${JAR_PLUGIN_BASENAME}_${JAR_PLUGIN_VERSION}.jar

PERL			?= perl

ISCC_OPTS		:= \
	/DJAR_PLUGIN=${JAR_PLUGIN} \
	/DJAR_PLUGIN_BASENAME=${JAR_PLUGIN_BASENAME}

ifeq ($(OS),Windows_NT)
EV3DUDER := ev3duder.exe
else
EV3DUDER := ev3duder
endif

.PHONY: artifacts artifacts-pre artifacts-build

c4ev3-withGCC-setup.exe: installer.iss artifacts-build
	@$(PERL) iscc.pl ${ISCC_OPTS} /DGCC_INSTALLER=${GCC_INSTALLER} installer.iss
	@rm -f isstmp_*

c4ev3-setup.exe: installer.iss artifacts-build
	@$(PERL) iscc.pl ${ISCC_OPTS} installer.iss
	@rm -f isstmp_*

artifacts/ev3duder/${EV3DUDER}:
	@$(MAKE) --no-print-directory -C ev3duder
	@cp -r ev3duder artifacts/

artifacts/${JAR_PLUGIN}:
	cd artifacts && \
	  curl -L --remote-name-all https://github.com/c4ev3/EV3-Eclipse-Plugin/files/3457078/${JAR_PLUGIN}.zip && \
	  7z x ${JAR_PLUGIN}.zip
	rm artifacts/${JAR_PLUGIN}.zip

artifacts/API/libev3api.a: API
	@$(MAKE) --no-print-directory -C API/API
	@cp -r API/API artifacts/

artifacts-pre:
	@mkdir -p artifacts

artifacts-build: artifacts-pre
	@$(MAKE) --no-print-directory artifacts

artifacts: artifacts/ev3duder/${EV3DUDER} artifacts/API/libev3api.a artifacts/${JAR_PLUGIN}

.PHONY: clean
clean:
	@$(MAKE) --no-print-directory -C ev3duder clean
	@$(MAKE) --no-print-directory -C API/API clean
	@rm -rf artifacts
	@rm -f isstmp_*
