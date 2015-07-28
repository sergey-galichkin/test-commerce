module Strings
  def self.get
    { 
      #UI elements
        #start page
        registration:       'Registration', 
        #create account page
        login:              'Email', 
        password:           'Password',
        pass_confirm:       'Confirm password',
        subdomain:          'Subdomain',
        name:               'Name',
        create_account_btn: 'Create Account',
        #themes index page
        create_theme_btn:   'Create New',
        status:             'Status',
        actions:            'Actions',
        delete:             'Delete',
        open_file_btn:      'file',
        upload_file_btn:      'Upload Theme',

      #Messages
        # Common
        authorization_error: 'You are not authorized to access this page.',
        #Themes index page
        theme_created:        'uploaded successfully',
        theme_deleted:        'successfully deleted',
        theme_blank_name_error:  "Name can't be blank",
        theme_file_ext_error:   'Zip file url is invalid',


      #URLs
        new_account_page:   '/accounts/new',
        themes_index_page:  '/themes',
        themes_new_page:  '/themes/new',
        themes_create_completed:  '/themes/create_completed',
    }
  end
end
