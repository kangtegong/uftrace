CC = gcc
RM = rm -f
FTRACE = ../../../ftrace -L ../../.. --flat

CFLAGS = -g -finstrument-functions

TARGETS = t-thumb t-arm-thumb

all: $(TARGETS)

TARGETS_O1 = $(patsubst %,%_O1,$(TARGETS))
TARGETS_O2 = $(patsubst %,%_O2,$(TARGETS))
TARGETS_O3 = $(patsubst %,%_O3,$(TARGETS))
TARGETS_Os = $(patsubst %,%_Os,$(TARGETS))

ALL_TARGETS = $(TARGETS) $(TARGETS_O1) $(TARGETS_O2) $(TARGETS_O3) $(TARGETS_Os)

all: $(ALL_TARGETS)

t-thumb: thumb.c
	$(CC) $(CFLAGS) -mthumb -o $@ $<

t-thumb_%: thumb.c
	$(CC) $(CFLAGS) -$(@:t-thumb_%=%) -mthumb -o $@ $<

t-arm-thumb: a.c t.c
	$(CC) $(CFLAGS) -marm -c a.c
	$(CC) $(CFLAGS) -mthumb -c t.c
	$(CC) $(CFLAGS) -o $@ a.o t.o

t-arm-thumb_%: a.c t.c
	$(CC) $(CFLAGS) -$(@:t-arm-thumb_%=%) -marm -c a.c
	$(CC) $(CFLAGS) -$(@:t-arm-thumb_%=%) -mthumb -c t.c
	$(CC) $(CFLAGS) -$(@:t-arm-thumb_%=%) -o $@ a.o t.o

test: all
	@echo testing -O0
	@for t in $(TARGETS); do \
		$(FTRACE) $$t 1 2 3 | sort -k2 | cut -d/ -f2 | cut -d, -f1 | \
		sed -e 's/<[0-9a-f]\+>/<unknown>/' > "$${t}_result"; \
	done;
	@echo testing -O1
	@for t in $(TARGETS_O1); do \
		$(FTRACE) $$t 1 2 3 | sort -k2 | cut -d/ -f2 | cut -d, -f1 | \
		sed -e 's/<[0-9a-f]\+>/<unknown>/' > tmp.result; \
		echo -n "  $${t}: "; diff -q "$${t%_O1}_result" tmp.result > /dev/null \
			&& echo OK || echo NG; \
		rm -f tmp.result; \
	done;
	@echo testing -O2
	@for t in $(TARGETS_O2); do \
		$(FTRACE) $$t 1 2 3 | sort -k2 | cut -d/ -f2 | cut -d, -f1 | \
		sed -e 's/<[0-9a-f]\+>/<unknown>/' > tmp.result; \
		echo -n "  $${t}: "; diff -q "$${t%_O2}_result" tmp.result > /dev/null \
			&& echo OK || echo NG; \
		rm -f tmp.result; \
	done;
	@echo testing -O3
	@for t in $(TARGETS_O3); do \
		$(FTRACE) $$t 1 2 3 | sort -k2 | cut -d/ -f2 | cut -d, -f1 | \
		sed -e 's/<[0-9a-f]\+>/<unknown>/' > tmp.result; \
		echo -n "  $${t}: "; diff -q "$${t%_O3}_result" tmp.result > /dev/null \
			&& echo OK || echo NG; \
		rm -f tmp.result; \
	done;
	@echo testing -Os
	@for t in $(TARGETS_Os); do \
		$(FTRACE) $$t 1 2 3 | sort -k2 | cut -d/ -f2 | cut -d, -f1 | \
		sed -e 's/<[0-9a-f]\+>/<unknown>/' > tmp.result; \
		echo -n "  $${t}: "; diff -q "$${t%_Os}_result" tmp.result > /dev/null \
			&& echo OK || echo NG; \
		rm -f tmp.result; \
	done;

clean:
	$(RM) $(ALL_TARGETS) *.o ftrace.data* gmon.out

.PHONY: clean test arch