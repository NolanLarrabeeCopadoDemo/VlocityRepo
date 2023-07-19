"use strict";

window.PostLib = (function(){
	return {
		createDescription : function(post) {

			var desc = "Created via social post:\n";

			if (post.mediaProvider.mediaTypeId == 1 || post.mediaProvider.mediaTypeId == 5){
				if (post.postTitle) {
					desc = desc + this.cleanupTitle(post.postTitle) + "\n\n";
				}
				desc = desc + post.plainTextContent.substr(0,310) + "...\n\n";
			}
			else if (post.mediaProvider.mediaTypeId != 8) { // do not include twitter content in description!
				if (post.postTitle) {
					desc = desc + this.cleanupTitle(post.postTitle) + "\n\n" + post.plainTextSummaryContent.trim() + "\n\n";
				}
				else {
					desc = desc + post.plainTextSummaryContent.trim() + "\n\n";
				}
			}

			if(post.author.profileLink) {
				desc +="Author Link: " + post.author.profileLink + "\n";
			}

			desc += "Post Link: " + post.externalLink;

			return desc;
		},

		cleanupTitle : function(title) {
			return title ? title.trim().replace(/<font color\=\"#(([0-9a-fA-F]{2}){3}|([0-9a-fA-F]){3})\"><b>/g, "").replace(/<\/b><\/font>/g, "") : title;
		},

		extractFirstName : function(post) {
			var firstName = "";
			if(post.author.authorFullName) {
				var parts = post.author.authorFullName.split(/\s/);
				if(parts.length > 1) {
					firstName = parts[0];
				}
			}
			return firstName;
		},

		extractLastName : function(post) {
			var lastName = "";
			if(post.author.authorFullName) {
				var parts = post.author.authorFullName.split(/\s/);
				if(parts.length === 1) {
					lastName = post.author.authorFullName;
				}
				else if(parts.length > 1) {
					lastName = parts.slice(1).join(" ");
				}
			}
			return lastName;
		},

		extractWebsite : function(post) {
			var website = post.author.profileLink || '';
			if(website === post.source.externalLink) {
				website = '';
			}
			return website;
		},

	}
}());
