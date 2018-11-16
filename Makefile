CC = g++
ROCKSDB_SRC = # add rocksdb folter here without any space.
CXXFLAGS = -Wall -g -DUSE_GLUSTER -DROCKSDB_PLATFORM_POSIX  -DOS_LINUX -std=c++11  -I$(ROCKSDB_SRC) -I$(ROCKSDB_SRC)/include
LDFLAGS = -L$(ROCKSDB_SRC) -O -lrocksdb -lgfapi -llz4 -lbz2 -lsnappy -lpthread -lzstd -lz 

all : basic_test.o env_gluster.o 
	$(CC) basic_test.o env_gluster.o -o basic_test $(LDFLAGS) -lgtest

%.o: %.cc env_gluster.h Makefile
	$(CC) $(CXXFLAGS) -c $< -o $@

shared_lib:env_gluster.o
	$(CC) $(CXXFLAGS) -o env-gluster.so -fPIC -shared env_gluster.cc -lgfapi -fvisibility=hidden

static_lib:env_gluster.o
	ar rcs env-gluster.a env_gluster.o
clean :
	rm -rf *.o basic_test *.so *.a