<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateUeTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('ue', function (Blueprint $table) {
            $table->increments('Id_UE')->unsigned();
            $table->string('Designation');
            $table->integer('Credit');
            $table->string('Niveau');
            $table->string('Parcours');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('ue');
    }
}
