#include <conio.h>
#include <stdlib.h>
#include <division.h>
#include <printf.h>

struct Segment {
    dword ceiling;
};

__mem struct Segment Segments[4];

struct List {
    dword address;
    struct List *next;
};

void print_list(struct List *head, struct Segment *Segment) {
    struct List *node = head;
    while(node) {
        printf("address = %x ", node->address);
        //asm{.byte $db}
        if(node->next>Segment->ceiling) {
            printf("this node address is larger than 0x11000\n");
        }

        node = node->next;
    }
printf("\n");
}

__mem struct List *base = 0x8000;


dword address_1 = 0x10000;
dword address_2 = 0x10400;
dword address_3 = 0x14000;

void main() {

    Segments[0].ceiling = 0x11001;
    Segments[0].ceiling = 0x11000;

    __mem struct List *head = 0x0;
    __mem struct List *tail = 0x0;

    __mem struct List *node = 0x0;

    head = base;
    tail = base;

    node = base;
    node->address = address_1;
    node->next = 0x0;

    print_list(head, &(Segments[0]));

    base += sizeof(struct List);
    struct List *new = base;
    new->address = address_2;
    new->next = 0x0;
    node->next = new;
    node = new;

    base += sizeof(struct List);
    new = base;
    new->address = address_3;
    new->next = 0x0;
    node->next = new;

    struct List *nodetest = node;

    if(node->next==nodetest->next) {
        printf("this assignment was done properly\n");
    }

    // this works ... 
    // (check the next statement, which results in error by commenting the below and uncomment the statement in error...)

    print_list(head, &Segments[0]);
}
