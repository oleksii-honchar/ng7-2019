import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RecipeBookComponent } from './components/recipe-book/recipe-book.component';
import { RecipeListComponent } from './components/recipe-list/recipe-list.component';
import { RecipeItemComponent } from './components/recipe-item/recipe-item.component';
import { RecipeDetailComponent } from './components/recipe-detail/recipe-detail.component';
import { RecipeComponent } from './components/recipe/recipe.component';
import { RecipeContainerComponent } from './recipe-container.component';

@NgModule({
  declarations: [
    RecipeBookComponent,
    RecipeListComponent,
    RecipeItemComponent,
    RecipeDetailComponent,
    RecipeComponent,
    RecipeContainerComponent
  ],
  exports: [
    RecipeContainerComponent,
  ],
  imports: [
    CommonModule
  ]
})
export class RecipeContainerModule { }
