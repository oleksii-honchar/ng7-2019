import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { CoreModule } from "./core/core.module";
import { SharedModule } from "./shared/shared.module";
import { RecipeContainerModule } from "./modules/recipe-container/recipe-container.module"
import { ShoppingListContainerModule } from "./modules/shopping-list-container/shopping-list-container.module"

@NgModule({
  declarations: [
    AppComponent
  ],
  imports: [
    AppRoutingModule,
    BrowserModule,
    FormsModule,
    CoreModule,
    SharedModule,
    RecipeContainerModule,
    ShoppingListContainerModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
