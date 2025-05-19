YOSYS=yosys
NEXTPNR=nextpnr-ice40
ICEPACK=icepack
ICEPROG=iceprog
IVERILOG=iverilog
VVP=vvp

TARGET=template
TEST_TARGET=template_test_bench
CONSTRAINTS_PATH=constraints.pcf
OUTPUT_DIRECTORY=build
PACKAGE=vq100
BOARD=hx1k
BUILD_PATH=build

.PHONY: init all

all: init synth route compile

init:
	mkdir -p ${BUILD_PATH}

synth: 
	${YOSYS} -p 'synth_ice40 -top ${TARGET} -json ${BUILD_PATH}/${TARGET}.json' ${TARGET}.v

route: 
	${NEXTPNR} --package ${PACKAGE} --${BOARD} --pcf ${CONSTRAINTS_PATH} --json ${BUILD_PATH}/${TARGET}.json --asc ${BUILD_PATH}/${TARGET}.asc

compile: 
	${ICEPACK} ${BUILD_PATH}/${TARGET}.asc ${BUILD_PATH}/${TARGET}.bin

flash:
	${ICEPROG} ${BUILD_PATH}/${TARGET}.bin

simulate:
	${IVERILOG} -o ${BUILD_PATH}/${TEST_TARGET}.vvp ${TEST_TARGET}.v
	${VVP} -o ${BUILD_PATH} ${BUILD_PATH}/${TEST_TARGET}.vvp
