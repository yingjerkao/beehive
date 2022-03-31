CUDA_PATH ?= /usr/local/cuda
NVCC          := $(CUDA_PATH)/bin/nvcc 


saxpy.e: saxpy.cu
	$(NVCC)  -o $@  $<

clean:
	rm *.e
