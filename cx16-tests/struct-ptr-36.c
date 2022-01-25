#include <conio.h>
#include <stdlib.h>
#include <division.h>
#include <printf.h>

struct List {
    char *name;
    struct List *next;
    struct List *prev;
};

char Sven[20] = "sven";
char Jesper[20] = "jesper";

struct List *base = 0x8000; // We use this memory to allocated the blocks.

void print_list(struct List *head) {
    struct List *node = head;
    while(node) {
        printf("name = %s ", node->name);
        node = node->next;
    }
printf("\n");
}

void main() {

    struct List *head = 0x0;
    struct List *tail = 0x0;

    struct List *node = 0x0;

    head = base;
    tail = base;

    node = base;
    node->name = Sven;
    node->next = 0x0;
    node->prev = 0x0;

    print_list(head);

    base += sizeof(struct List);
    struct List *new = base;
    new->name = Jesper;
    new->next = 0x0;
    new->prev = node;

    // this works ... 
    // (check the next statement, which results in error by commenting the below and uncomment the statement in error...)
    struct List *node_prev = new->prev;
    node_prev->next = new;

    //new->prev->next = node; // This statement results in an error...
    // java.lang.RuntimeException: Not implemented struct List***
    //     at dk.camelot64.kickc.fragment.AsmFragmentInstanceSpecBuilder.getTypePrefix(AsmFragmentInstanceSpecBuilder.java:513)
    //     at dk.camelot64.kickc.fragment.AsmFragmentInstanceSpecBuilder.bind(AsmFragmentInstanceSpecBuilder.java:445)
    //     at dk.camelot64.kickc.fragment.AsmFragmentInstanceSpecBuilder.bind(AsmFragmentInstanceSpecBuilder.java:405)
    //     at dk.camelot64.kickc.fragment.AsmFragmentInstanceSpecBuilder.bind(AsmFragmentInstanceSpecBuilder.java:341)
    //     at dk.camelot64.kickc.fragment.AsmFragmentInstanceSpecBuilder.bind(AsmFragmentInstanceSpecBuilder.java:415)
    //     at dk.camelot64.kickc.fragment.AsmFragmentInstanceSpecBuilder.bind(AsmFragmentInstanceSpecBuilder.java:316)
    //     at dk.camelot64.kickc.fragment.AsmFragmentInstanceSpecBuilder.assignmentSignature(AsmFragmentInstanceSpecBuilder.java:212)
    //     at dk.camelot64.kickc.fragment.AsmFragmentInstanceSpecBuilder.<init>(AsmFragmentInstanceSpecBuilder.java:135)
    //     at dk.camelot64.kickc.fragment.AsmFragmentInstanceSpecBuilder.assignment(AsmFragmentInstanceSpecBuilder.java:128)
    //     at dk.camelot64.kickc.passes.Pass4CodeGeneration.generateStatementAsm(Pass4CodeGeneration.java:861)
    //     at dk.camelot64.kickc.passes.Pass4CodeGeneration.genStatements(Pass4CodeGeneration.java:799)
    //     at dk.camelot64.kickc.passes.Pass4CodeGeneration.generate(Pass4CodeGeneration.java:147)
    //     at dk.camelot64.kickc.Compiler.pass4RegisterAllocation(Compiler.java:681)
    //     at dk.camelot64.kickc.Compiler.compile(Compiler.java:198)
    //     at dk.camelot64.kickc.KickC.call(KickC.java:384)
    //     at dk.camelot64.kickc.KickC.call(KickC.java:26)
    //     at picocli.CommandLine.executeUserObject(CommandLine.java:1933)
    //     at picocli.CommandLine.access$1200(CommandLine.java:145)
    //     at picocli.CommandLine$RunLast.executeUserObjectOfLastSubcommandWithSameParent(CommandLine.java:2332)
    //     at picocli.CommandLine$RunLast.handle(CommandLine.java:2326)
    //     at picocli.CommandLine$RunLast.handle(CommandLine.java:2291)
    //     at picocli.CommandLine$AbstractParseResultHandler.execute(CommandLine.java:2159)
    //     at picocli.CommandLine.execute(CommandLine.java:2058)
    //     at dk.camelot64.kickc.KickC.main(KickC.java:189)    
    
    print_list(head);
}
