#include <stdio.h>
#include <stdlib.h>

typedef struct Node {
    int val;
    struct Node *next;
} Node;

typedef struct {
    Node *head;
    Node *tail;
    int size;
} Queue;

Queue *queue_new() {
    Queue *q = malloc(sizeof(Queue));
    q->head = q->tail = NULL;
    q->size = 0;
    return q;
}

void queue_push(Queue *q, int val) {
    Node *n = malloc(sizeof(Node));
    n->val = val;
    n->next = NULL;
    if (q->tail) q->tail->next = n;
    else q->head = n;
    q->tail = n;
    q->size++;
}

int queue_pop(Queue *q) {
    if (!q->head) return -1;
    Node *n = q->head;
    int val = n->val;
    q->head = n->next;
    if (!q->head) q->tail = NULL;
    free(n);
    q->size--;
    return val;
}
