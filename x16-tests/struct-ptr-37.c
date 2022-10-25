#include <conio.h>
#include <stdlib.h>
#include <division.h>
#include <printf.h>

struct List {
    int number;
    struct List *next;
};

void print_list(struct List *head) {
    struct List *node = head;
    while(node) {
        printf("name = %d ", node->number);
        //asm{.byte $db}
        if(node->next==0x0) {
            printf("this is the last node\n");
        }
        if(node->next!=0x0) {
            printf("this is not the last node\n");
        }

        node = node->next;
    }
printf("\n");
}

__mem int num_20 = 20;
__mem int num_40 = 40;
__mem int num_60 = 60;

void main() {

    __mem struct List *head = 0x0;
    __mem struct List *tail = 0x0;

    __mem struct List *node = 0x0;

    head = base;
    tail = base;

    node = base;
    node->number = num_20;
    node->next = 0x0;

    print_list(head);

    base += sizeof(struct List);
    __mem struct List *new = base;
    new->number = num_40;
    new->next = 0x0;
    node->next = new;
    node = new;

    base += sizeof(struct List);
    new = base;
    new->number = num_60;
    new->next = 0x0;
    node->next = new;

    struct List *nodetest = node;

    if(node->next==nodetest->next) {
        printf("this assignment was done properly\n");
    }

    // this works ... 
    // (check the next statement, which results in error by commenting the below and uncomment the statement in error...)

    print_list(head);
}
