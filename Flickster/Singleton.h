#define SingletonImplementation                 \
+ (instancetype)sharedInstance                  \
{                                               \
    static dispatch_once_t once;                \
    static id instance;                         \
    dispatch_once(&once, ^                      \
    {                                           \
        instance = [[self alloc] init];         \
    });                                         \
    return instance;                            \
}

@protocol Singleton

+ (instancetype)sharedInstance;

@end