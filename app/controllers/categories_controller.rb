class CategoriesController < ApplicationController
    
    before_action :set_category, only: [:edit, :update, :destroy, :show]
    before_action :require_admin, except: [:show, :python]

    #--------ADMIN PAGE-------------------------
    def admin
        @categories = Category.all.order(sort_column + " " + sort_direction)
    
        #for csv downloader
        respond_to do |format|
            format.html
            format.csv {render text: @categories.to_csv }
        end
    end
    
    #method is used for csv file upload
    def import
        Category.import(params[:file])
        flash[:success] = 'Categories were successfully imported'
        redirect_to category_admin_path 
    end
    
    def search
        @q = "%#{params[:query]}%"
        @categories = Category.where("name LIKE ? or keywords LIKE ?", @q, @q).order(sort_column + " " + 
                                    sort_direction).paginate(page: params[:page], per_page: 50)
        render 'admin'
    end
    #--------ADMIN PAGE-------------------------
    
    #-------------------------------------------
    def new
      @category = Category.new
    end
    def create
        #render plain: params[:category].inspect
        @category = Category.new(category_params)
        if @category.save
            flash[:success] = 'Category was successfully created'
            redirect_to category_admin_path
        else 
            render 'new'
        end
    end
    
    #-------------------------------------------
    
    def show
        
        #sort by the option selected by user
        if params[:option] != nil
            @sort_option = SortOption.find(params[:option])
            
            if @sort_option != nil
                #add a click to the sort option
                @sort_option.increment(:num_clicks, by = 1)
                @sort_option.save
                
                @articles = @category.articles.order(@sort_option.query + " " + @sort_option.direction).page(params[:page]).per_page(24)
            else 
                @articles = @category.articles.order("created_at DESC").page(params[:page])    
            end
        else 
            @articles = @category.articles.order("created_at DESC").page(params[:page])
        end        
        
    end

    #-------------------------------------------
    
    def edit
    end   
    def update
        if @category.update(category_params)
            flash[:success] = 'Category was successfully updated'
            redirect_to category_admin_path
        else 
            render 'edit'
        end
    end 
    
    #-------------------------------------------
   
    def destroy
        @category.destroy
        flash[:success] = 'Category was successfully deleted'
        redirect_to category_admin_path
    end
   
    def destroy_multiple
        Category.destroy(params[:categories])
        flash[:success] = 'Categories were successfully deleted'
        redirect_to category_admin_path        
    end
    
    #-------------------------------------------

  
    private
    
        def require_admin
            if !logged_in? || (logged_in? and !current_user.admin?)
                redirect_to root_path
            end
        end
        
        def set_category
          @category = Category.find(params[:id])
        end
        
        def category_params
          params.require(:category).permit(:name, :keywords, :active, :category_type)
        end  
        
        def sort_column
            params[:sort] || "name"
        end
        def sort_direction
            params[:direction] || 'desc'
        end
end