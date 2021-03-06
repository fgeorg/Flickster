//
//  FKFlickrPhotosetsEditPhotos.m
//  FlickrKit
//
//  Generated by FKAPIBuilder on 19 Sep, 2014 at 10:49.
//  Copyright (c) 2013 DevedUp Ltd. All rights reserved. http://www.devedup.com
//
//  DO NOT MODIFY THIS FILE - IT IS MACHINE GENERATED


#import "FKFlickrPhotosetsEditPhotos.h" 

@implementation FKFlickrPhotosetsEditPhotos



- (BOOL) needsLogin {
    return YES;
}

- (BOOL) needsSigning {
    return YES;
}

- (FKPermission) requiredPerms {
    return 1;
}

- (NSString *) name {
    return @"flickr.photosets.editPhotos";
}

- (BOOL) isValid:(NSError **)error {
    BOOL valid = YES;
	NSMutableString *errorDescription = [[NSMutableString alloc] initWithString:@"You are missing required params: "];
	if(!self.photoset_id) {
		valid = NO;
		[errorDescription appendString:@"'photoset_id', "];
	}
	if(!self.primary_photo_id) {
		valid = NO;
		[errorDescription appendString:@"'primary_photo_id', "];
	}
	if(!self.photo_ids) {
		valid = NO;
		[errorDescription appendString:@"'photo_ids', "];
	}

	if(error != NULL) {
		if(!valid) {	
			NSDictionary *userInfo = @{NSLocalizedDescriptionKey: errorDescription};
			*error = [NSError errorWithDomain:FKFlickrKitErrorDomain code:FKErrorInvalidArgs userInfo:userInfo];
		}
	}
    return valid;
}

- (NSDictionary *) args {
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
	if(self.photoset_id) {
		[args setValue:self.photoset_id forKey:@"photoset_id"];
	}
	if(self.primary_photo_id) {
		[args setValue:self.primary_photo_id forKey:@"primary_photo_id"];
	}
	if(self.photo_ids) {
		[args setValue:self.photo_ids forKey:@"photo_ids"];
	}

    return [args copy];
}

- (NSString *) descriptionForError:(NSInteger)error {
    switch(error) {
		case FKFlickrPhotosetsEditPhotosError_PhotosetNotFound:
			return @"Photoset not found";
		case FKFlickrPhotosetsEditPhotosError_PhotoNotFound:
			return @"Photo not found";
		case FKFlickrPhotosetsEditPhotosError_PrimaryPhotoNotFound:
			return @"Primary photo not found";
		case FKFlickrPhotosetsEditPhotosError_PrimaryPhotoNotInList:
			return @"Primary photo not in list";
		case FKFlickrPhotosetsEditPhotosError_EmptyPhotosList:
			return @"Empty photos list";
		case FKFlickrPhotosetsEditPhotosError_SSLIsRequired:
			return @"SSL is required";
		case FKFlickrPhotosetsEditPhotosError_InvalidSignature:
			return @"Invalid signature";
		case FKFlickrPhotosetsEditPhotosError_MissingSignature:
			return @"Missing signature";
		case FKFlickrPhotosetsEditPhotosError_LoginFailedOrInvalidAuthToken:
			return @"Login failed / Invalid auth token";
		case FKFlickrPhotosetsEditPhotosError_UserNotLoggedInOrInsufficientPermissions:
			return @"User not logged in / Insufficient permissions";
		case FKFlickrPhotosetsEditPhotosError_InvalidAPIKey:
			return @"Invalid API Key";
		case FKFlickrPhotosetsEditPhotosError_ServiceCurrentlyUnavailable:
			return @"Service currently unavailable";
		case FKFlickrPhotosetsEditPhotosError_WriteOperationFailed:
			return @"Write operation failed";
		case FKFlickrPhotosetsEditPhotosError_FormatXXXNotFound:
			return @"Format \"xxx\" not found";
		case FKFlickrPhotosetsEditPhotosError_MethodXXXNotFound:
			return @"Method \"xxx\" not found";
		case FKFlickrPhotosetsEditPhotosError_InvalidSOAPEnvelope:
			return @"Invalid SOAP envelope";
		case FKFlickrPhotosetsEditPhotosError_InvalidXMLRPCMethodCall:
			return @"Invalid XML-RPC Method Call";
		case FKFlickrPhotosetsEditPhotosError_BadURLFound:
			return @"Bad URL found";
  
		default:
			return @"Unknown error code";
    }
}

@end
