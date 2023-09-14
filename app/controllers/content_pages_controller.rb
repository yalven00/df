class ContentPagesController < ApplicationController

	def show
    @content_page = ContentPage.find_by_path(params[:path])
		@title = @content_page.meta_title
		@meta_description = @content_page.meta_description
		@meta_keywords = @content_page.meta_keywords
	end

end
