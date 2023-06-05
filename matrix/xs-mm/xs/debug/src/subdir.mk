################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../src/Eq.cpp \
../src/app.cpp \
../src/apple.cpp \
../src/code.cpp \
../src/desktop.cpp \
../src/hack.cpp \
../src/input.cpp \
../src/loveapple.cpp \
../src/macOs.cpp \
../src/microsoft.cpp \
../src/perl.cpp \
../src/run.cpp \
../src/star.cpp \
../src/sun.cpp \
../src/time.cpp \
../src/xs.cpp 

OBJS += \
./src/Eq.o \
./src/app.o \
./src/apple.o \
./src/code.o \
./src/desktop.o \
./src/hack.o \
./src/input.o \
./src/loveapple.o \
./src/macOs.o \
./src/microsoft.o \
./src/perl.o \
./src/run.o \
./src/star.o \
./src/sun.o \
./src/time.o \
./src/xs.o 

CPP_DEPS += \
./src/Eq.d \
./src/app.d \
./src/apple.d \
./src/code.d \
./src/desktop.d \
./src/hack.d \
./src/input.d \
./src/loveapple.d \
./src/macOs.d \
./src/microsoft.d \
./src/perl.d \
./src/run.d \
./src/star.d \
./src/sun.d \
./src/time.d \
./src/xs.d 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.cpp src/subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C++ Compiler'
	g++ -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


